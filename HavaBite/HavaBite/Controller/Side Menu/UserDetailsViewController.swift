//
//  UserDetailsViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/24/24.
//

import UIKit

class UserDetailsViewController: UIViewController {
    var user: User?

    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.text = user?.email
        nameLabel.text = "\(user!.first_name) \(user!.last_name)"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
