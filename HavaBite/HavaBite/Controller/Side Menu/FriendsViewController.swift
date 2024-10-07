//
//  FriendsViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/6/24.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var friendsList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsList.backgroundColor = #colorLiteral(red: 0.5989779234, green: 0.825442493, blue: 0.8293678164, alpha: 1)
        // Do any additional setup after loading the view.
        
        sideMenuButton.target = revealViewController()
        sideMenuButton.action = #selector(revealViewController()?.revealSideMenu)
        
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
