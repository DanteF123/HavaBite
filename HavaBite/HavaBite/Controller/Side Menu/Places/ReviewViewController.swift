//
//  ReviewViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/30/24.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController {
    
    let db = Firestore.firestore()
    let currentUser = UserSession.shared.currentUser
    
    @IBOutlet weak var ratingTextField: UITextField!
    
    var place: PlaceAnnotation?
    
    @IBOutlet weak var restaurantName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantName.text = "Rate \(place!.name)"
    }
    // Upon button click, submit rating to Firebase.
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        postReview()
    }
    
    
}


extension ReviewViewController{
    func verifyInput(){
        
    }
    
    func postReview(){
        let reviewRef = db.collection("users").document(currentUser!.uid).collection("reviews").document(place!.id)
        reviewRef.setData(["rating":5]){error in
            if let error = error {
                print("Error posting review: \(error)")
                //            } else {
                //
                //                if UserSession.shared.friends.contains(userRef.documentID) {
                //                    let message = "Friend Already Added"
                //                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                //                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                //
                //                    })
                //                    self.present(alert, animated: true, completion: nil)
                //
                //                }
                //                else{
                //
                //                    UserSession.shared.friends.insert(self.user!.id)
                //                    let message = "Friend Added"
                //                    let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                //                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                //
                //                    })
                //                    self.present(alert, animated: true, completion: nil)
                //
                //                }
                //
                //            }
            }
            
        }
    }
}
