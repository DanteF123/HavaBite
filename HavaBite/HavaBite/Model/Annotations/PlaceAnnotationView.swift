//
//  PlaceAnnotationView.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/25/24.
//

import Foundation
import UIKit
import MapKit

class PlaceAnnotationView: MKAnnotationView {
    
    // Initialize the custom annotation view
    override var annotation: MKAnnotation? {
        willSet {
            guard let placeAnnotation = newValue as? PlaceAnnotation else { return }
            canShowCallout = true
            
            // Add custom label for the rating
            let ratingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            ratingLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            ratingLabel.textColor = .black
            ratingLabel.textAlignment = .center
            ratingLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
            // Set the rating value as the text of the label
            ratingLabel.text = String(format:"%.1f",placeAnnotation.rating)
            
            // Add rating label as a subview
            addSubview(ratingLabel)
            
            // Optionally set an image or pin
            image = UIImage(systemName: "mappin.circle.fill") // Example using SF Symbol
        }
    }
}
