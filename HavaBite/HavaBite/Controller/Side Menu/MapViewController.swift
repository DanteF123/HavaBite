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
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager, let location = locationManager.location else {return}
        
        switch locationManager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("")
        case .notDetermined, .restricted:
            print("")
        @unknown default:
            print("")
        }
        
    }


}




//Map View Delegate methods
extension MapViewController {
    
    private func clearAllSelections(){
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        
    }
    
    // This method provides the custom annotation view

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
