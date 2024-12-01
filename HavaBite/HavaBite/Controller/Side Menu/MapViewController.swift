//
//  MapViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/18/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    private var places: [PlaceAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sideMenuButton.target = revealViewController()
        sideMenuButton.action = #selector(revealViewController()?.revealSideMenu)
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        //initialize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
        checkLocationAuthorization()

    }
    
    
    //TODO: Figure out how to handle the user rejecting 
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = locationManager.location {
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1750, longitudinalMeters: 1750)
                mapView.setRegion(region, animated: true)
                getNearbyRestaurants(for: region)
            }
        case .denied:
            // Show an alert asking the user to enable permissions in Settings
            let alert = UIAlertController(
                title: "Location Permission Denied",
                message: "Location access is needed to show nearby restaurants. Please enable it in Settings.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            })
            self.present(alert, animated: true, completion: nil)
            
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            print("Unknown authorization status.")
        }
    }
    
    
    
    private func presentPlacesSheet(places: [PlaceAnnotation]){
        
        guard let locationManager = locationManager,
              let userLocation = locationManager.location else {return}
        
        let placesTVC = PlacesTableViewController(userLocation: userLocation, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTVC.sheetPresentationController{
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(),.large()]
            present(placesTVC,animated: true)
        }
    }
    
    //function to get nearby restaurants
    private func getNearbyRestaurants(for region: MKCoordinateRegion) {
        var expandedRegion = region
        expandedRegion.span.latitudeDelta *= 2  // Expanding the search area
        expandedRegion.span.longitudeDelta *= 2

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Restaurant"
        request.region = expandedRegion

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self, let response = response, error == nil else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Map results to PlaceAnnotation and add to both annotations and list
            let newPlaces = response.mapItems.map { PlaceAnnotation(mapItem: $0) }
            
            // Add only unique places to avoid duplication
            for place in newPlaces {
                if !self.places.contains(where: { $0.id == place.id }) {
                    
                    self.places.append(place)
                    
    
                    //place id
                    print(place.id)
                    self.mapView.addAnnotation(place)  // Add to map
                }
            }
            
            // Present updated list with all map annotations
            self.presentPlacesSheet(places: self.places)
        }
    }


}


//Map View Delegate methods
extension MapViewController {
    
    private func clearAllSelections(){
        self.places = self.places.map{
            place in place.isSelected = false
            return place
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        // Clear all selections
        clearAllSelections()

        guard let selectedAnnotation = annotation as? PlaceAnnotation else { return }
        
        // Set the selected annotation's `isSelected` property to true
        if let placeAnnotation = self.places.first(where: { $0.id == selectedAnnotation.id }) {
            placeAnnotation.isSelected = true
        }
        
        // Move the selected annotation to the top of the list
        let sortedPlaces = self.places.sorted { $0.isSelected && !$1.isSelected }
        presentPlacesSheet(places: sortedPlaces)
    }


}


//Location manager
extension MapViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
}
