//
//  RegisterViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/14/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var firstnameText: UITextField!
    
    @IBOutlet weak var lastnameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    let db = Firestore.firestore()
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        register()
    }
}


extension RegisterViewController{
    
    func register() -> Bool{
        if let firstName = firstnameText.text, let lastName = lastnameText.text, let email = emailText.text, let password = passwordText.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    let message = e.localizedDescription
                    let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if let user = authResult?.user {
                        let userID = user.uid
                        self.db.collection("users").document(userID).setData([
                            "email": email,
                            "first_name": firstName,
                            "last_name":lastName
                        ]) { error in
                            if let error = error {
                                print("Error adding user: \(error)")
                            } else {
                                print("User added successfully")
                            }
                        }
                    }
                    
                    let message = "User Created"
                    let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        return true
            
    }
    
}