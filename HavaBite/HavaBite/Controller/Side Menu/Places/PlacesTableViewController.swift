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
    
    func calculateDistance(from: CLLocation, to:CLLocation) -> CLLocationDistance{
        from.distance(from: to)
    }
    
    func formatDistanceForDisplay(_ distance: CLLocationDistance) ->String{
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: .miles).formatted()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
//        let placeDetailVC = PlaceDetailsViewController(place: place)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let placeDetailsVC = storyboard.instantiateViewController(withIdentifier: "PlaceDetailsID") as? PlaceDetailsViewController {
            placeDetailsVC.place = place
            
            // Set the modal presentation style
            placeDetailsVC.modalPresentationStyle = .pageSheet
            
            if let sheet = placeDetailsVC.sheetPresentationController {
                // Set the preferred content size
                sheet.detents = [.medium()] // Medium covers roughly half the screen
                sheet.prefersGrabberVisible = true // Optional: Shows a grabber at the top of the sheet
            }
            
            self.present(placeDetailsVC, animated: true)
        } else {
            print("Error: Could not instantiate UserDetailsViewController")
        }
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableCell.identifier, for: indexPath) as? RestaurantTableCell else { fatalError("xib does not exist")
        }
        let place = places[indexPath.row]
        
        cell.restaurant.text = place.name
        cell.restaurantDistance.text = formatDistanceForDisplay(calculateDistance(from: userLocation, to: place.location))
        
        if let rating = place.rating {
            cell.restaurantRating.text = String(format: "%.1f", rating)
        } else {
            cell.restaurantRating.text = ""
        }
        
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
