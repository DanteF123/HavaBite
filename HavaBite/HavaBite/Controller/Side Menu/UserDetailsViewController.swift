//
//  UserDetailsViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/24/24.
//

import UIKit
import Firebase
import FirebaseAuth

class UserDetailsViewController: UIViewController {
    var user: User?

    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.text = user?.email
        nameLabel.text = "\(user!.first_name) \(user!.last_name)"

        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func addFriendButtonClick(_ sender: UIButton) {
        addFriend()
    }
    
}

extension UserDetailsViewController{
    
    func addFriend(){
        let userRef = db.collection("users").document(currentUser!.uid).collection("users").document(user!.id)
        userRef.setData(["email":user!.email, "first_name":user!.first_name, "last_name":user!.last_name]){error in
            if let error = error {
                print("Error adding post: \(error)")
            } else {
                //update application set so the user does not have to sign out and sign back in for friend to appear.
                UserSession.shared.friends.insert(self.user!.id)
                let message = "Friend Added"
                let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                    // Navigate to Hello after the alert is dismissed
//                        self.performSegue(withIdentifier: "registerToHello", sender: self)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}
