//
//  PlacesTableViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/25/24.
//


import Foundation
import UIKit
import MapKit

class PlacesTableViewController: UITableViewController{
    var userLocation: CLLocation
    var places: [PlaceAnnotation]
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        //register cell
        tableView.register(RestaurantTableCell.nib, forCellReuseIdentifier: RestaurantTableCell.identifier)
        // Enable automatic row height
        tableView.rowHeight = 85
        
        self.places.swapAt(indexForSelectedRow, 0)
    }
    
    private var indexForSelectedRow:Int{
        self.places.firstIndex(where: {$0.isSelected == true}) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    private func calculateDistance(from: CLLocation, to:CLLocation) -> CLLocationDistance{
        from.distance(from: to)
    }
    
    private func formatDistanceForDisplay(_ distance: CLLocationDistance) ->String{
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: .miles).formatted()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let placeDetailVC = PlaceDetailViewController(place: place)
        present(placeDetailVC,animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableCell.identifier, for: indexPath) as? RestaurantTableCell else { fatalError("xib does not exist")
        }
        let place = places[indexPath.row]
        
        cell.restaurant.text = place.name
        cell.restaurantDistance.text = formatDistanceForDisplay(calculateDistance(from: userLocation, to: place.location))
        
        cell.restaurantRating.text = "0"
        
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
