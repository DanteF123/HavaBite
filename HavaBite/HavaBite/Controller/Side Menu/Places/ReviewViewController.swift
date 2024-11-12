//
//  ReviewViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/30/24.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    let currentUser = UserSession.shared.currentUser
    
    @IBOutlet weak var ratingTextField: UITextField!
    
    var place: PlaceAnnotation?
    
    @IBOutlet weak var restaurantName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingTextField.delegate = self
        ratingTextField.keyboardType = .numberPad

        restaurantName.text = "Rate \(place?.name ?? "")"
    }
    // Upon button click, submit rating to Firebase.
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        postReview(review: self.ratingTextField.text ?? " ")
        print(currentUser!.email)
    }
    
    
}


extension ReviewViewController{
    func validateInput(input:String) -> Int {
        let input = Int(input) ?? 0
        if input <= 0 || input > 5 {
            let message = "Please enter a number between 1 and 5."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in

            })
            self.present(alert, animated: true, completion: nil)
            
            self.ratingTextField.text = ""
            
            return -1
        }
        
        else{
            
            let message = "Rating successfully submitted."
            let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in

            })
            self.present(alert, animated: true, completion: nil)
            
            self.ratingTextField.text = ""
            return input
        }
        
    }
    
    func postReview(review:String){
        
        let review = self.validateInput(input: review)
        
        if review != -1{
            
            let reviewRef = db.collection("users").document(currentUser!.uid).collection("reviews").document(place!.id)
            reviewRef.setData(["rating":review, "restaurant":self.place?.name ?? ""]){error in
                if let error = error {
                    print("Error posting review: \(error)")

                }
                
            }
            
            
        }

    }
}
