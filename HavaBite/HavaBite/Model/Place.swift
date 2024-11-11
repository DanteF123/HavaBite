//
//  Place.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/29/24.
//

import Foundation

class Place{
    
    let address:String
    let phone:String
    let id:UUID
    let placeAnnotation: PlaceAnnotation
    
    init(address: String, phone: String, id: UUID, placeAnnotation:PlaceAnnotation) {
        self.address = address
        self.phone = phone
        self.id = id
        self.placeAnnotation = placeAnnotation
    }
    
    
}
