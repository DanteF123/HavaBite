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
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // Dismisses the keyboard when tapping outside of text fields
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        register(firstName: firstnameText.text ?? "", lastName: lastnameText.text ?? "",
                 email: emailText.text ?? "", password: passwordText.text ?? ""){ success in
            if success {
                
                let message = "User Created"
                let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                    self.performSegue(withIdentifier: "registerToMain", sender: self)
                })
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("Login failed")
            }
        }
    }
}


extension RegisterViewController{
    
    func register(firstName:String, lastName:String, email:String, password:String, completion: @escaping (Bool) -> Void) -> Bool{
        if firstName != "" && lastName != "" && email != "" &&  password != "" {
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
                                
                                
                            } else if let firebaseUser = authResult?.user {
                                
                                UserSession.shared.initializeLoggedInUser(with: firebaseUser) {
                                    // Only after the session is properly set up do we proceed
                                    completion(true)
                                }
                                
                            }
                            else {
                                completion(false)
                            }

                        }
                    }
                    

                }
            }
            return true
        }
        
        else{
            let message = "Please ensure all fields are filled."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                // Navigate to Hello after the alert is dismissed
                self.performSegue(withIdentifier: "registerToMain", sender: self)
            })
            self.present(alert, animated: true, completion: nil)
            return false
        }
            
    }
    
}

//filling in method to handle keyboard hide and show
extension RegisterViewController{
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardSize.cgRectValue
            // Adjust the view's position by moving it up
            self.view.frame.origin.y = -keyboardFrame.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset the view's position
        self.view.frame.origin.y = 0
    }
    
}
