//
//  PlaceAnnotation.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/25/24.
//

import Foundation
import MapKit

class PlaceAnnotation: MKPointAnnotation{
    let mapItem: MKMapItem
    let id : String
    var isSelected:Bool = false
    
    init(mapItem: MKMapItem){
        self.mapItem = mapItem
        
        self.id = "LAT:\(mapItem.placemark.coordinate.latitude.description) LONG:\(mapItem.placemark.coordinate.longitude.description)"
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
    
    var name: String{
        mapItem.name ?? ""
    }
    
    var phone: String{
        mapItem.phoneNumber ?? ""
    }
    
    var location: CLLocation{
        mapItem.placemark.location ?? CLLocation.default
    }
    
    
}