//
//  SideMenuViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/16/24.
//

import UIKit
import FirebaseAuth

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController{
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var roundedView: UIView!
    
    
    var delegate: SideMenuViewControllerDelegate?
    var defaultHighlightedCell: Int = 0
    
    let currentUser = UserSession.shared.currentUser
    
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "globe.americas.fill")!, title: "Map"),
        SideMenuModel(icon: UIImage(systemName: "magnifyingglass")!, title: "Search"),
        SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "Friends"),
        SideMenuModel(icon: UIImage(systemName: "figure.walk")!, title: "Log Out")
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //round view
        roundedView.layer.cornerRadius = 20
        roundedView.clipsToBounds = true

        // TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = #colorLiteral(red: 0.5989779234, green: 0.825442493, blue: 0.8293678164, alpha: 1)
        self.tableView.separatorStyle = .none
        
        //Adding accessibilityIdentifier
        tableView.accessibilityIdentifier = "SideMenuTable"
        
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.tableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
            
            //set label to email
            self.headerLabel.text = UserSession.shared.loggedInUser!.first_name
            
        }
        
        // Register TableView Cell
        self.tableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        
        // Update TableView with the data
        self.tableView.reloadData()
        
    }
    
}

// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}


// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
        
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
        // ...
        
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
