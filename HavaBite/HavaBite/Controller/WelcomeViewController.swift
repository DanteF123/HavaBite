//
//  WelcomeViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/11/24.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting delegates to self so that keyboard is dismissed when return is tapped.
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  // Dismiss the keyboard
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // Dismisses the keyboard when tapping outside of text fields
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    @IBAction func logInButtonClicked(_ sender: Any) {
        logIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { success in
            if success {
                self.performSegue(withIdentifier: "logIntoMain", sender: self)
            } else {
                print("Login failed")
            }
        }
    }
    
}

extension WelcomeViewController {
    
    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        if email != "" && password != "" {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    let message = e.localizedDescription
                    let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    completion(false)
                } else if let firebaseUser = authResult?.user {
                    // Initialize the UserSession singleton after successful login
                    UserSession.shared.initializeLoggedInUser(with: firebaseUser) {
                        // Only after the session is properly set up do we proceed
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            }
        } else {
            let message = "Please ensure all fields are filled."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true, completion: nil)
            completion(false)
        }
    }
    
    
}
