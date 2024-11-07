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
    
    
    var place: PlaceAnnotation?
    
    override func viewDidLoad() {
        //Setting up the view assigning text to labels.
        super.viewDidLoad()
        restaurantLabel.text = place?.name
        phoneLabel.text = place?.phone
    }
    //Upon button click, pass the selected and inflate the ReviewViewController
    @IBAction func reviewButtonClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let reviewDetailsVC = storyboard.instantiateViewController(withIdentifier: "ReviewID") as? ReviewViewController {
            reviewDetailsVC.place = place
            
            
            self.present(reviewDetailsVC, animated: true)
        } else {
            print("Error: Could not instantiate UserDetailsViewController")
        }
        
    }
    
}
