//
//  PlaceDetailsViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/30/24.
//

import Foundation
import UIKit


class PlaceDetailsViewController: UIViewController{
    @IBOutlet weak var restaurantLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var reviewButton: UIButton!
    
    var place: PlaceAnnotation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantLabel.text = place?.name
        phoneLabel.text = place?.phone
    }
    

}
