//
//  WelcomeViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/11/24.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
    
}
