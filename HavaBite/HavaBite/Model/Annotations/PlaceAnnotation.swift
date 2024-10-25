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
    let id = UUID()
    var isSelected:Bool = false
    var rating: Double // New rating property
    
    init(mapItem: MKMapItem,  rating: Double = 0.0){
        self.mapItem = mapItem
        self.rating = rating
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
