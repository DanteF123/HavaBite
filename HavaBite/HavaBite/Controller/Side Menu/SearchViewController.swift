//
//  SearchViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/18/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchResults: UITableView!
    
    var users: [User] = []
    var filteredUsers: [User] = [] // Add filtered users array
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults.dataSource = self
        searchResults.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        searchBar.delegate = self // Set the search bar delegate
        getAllUsers()
        addTapGestureRecognizer()
        
        sideMenuButton.target = revealViewController()
        sideMenuButton.action = #selector(revealViewController()?.revealSideMenu)

        // Do any additional setup after loading the view.
    }
    
    func filterUsers(for searchText: String) {
        filteredUsers = users.filter { user in
            return user.email.lowercased().contains(searchText.lowercased())
        }
        searchResults.reloadData()
    }

    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowercaseSearchText = searchText.lowercased()
        searchBar.text = lowercaseSearchText  // Display the search text in lowercase
        if lowercaseSearchText.isEmpty {
            filteredUsers = users
        } else {
            filterUsers(for: lowercaseSearchText)
        }
        searchResults.reloadData()
    }
    
    @objc func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredUsers = users
        searchResults.reloadData()
        searchBar.resignFirstResponder()
    }

}




extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listItem = filteredUsers[indexPath.row].email
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        cell.textLabel?.text = listItem
        return cell
    }
}

extension SearchViewController {
    func getAllUsers() {
        let db = Firestore.firestore()
        let userRef = db.collection("users")
        
        userRef.getDocuments(completion: { querySnapshot, error in
            if let error = error {
                print("Error getting users \(error)")
            } else {
                for i in querySnapshot!.documents {
                    print(i)
                    if i.documentID != self.currentUser!.uid {
                        let data = i.data()
                        let user_email = data["email"]
                        let user_first_name = data["first_name"]
                        let user_last_name = data["last_name"]
                        let id = i.documentID
                        
                        let user = User(first_name: user_first_name as? String ?? "",
                                        last_name: user_last_name as? String ?? "",
                                        email: user_email as? String ?? "",
                                        id: id)
                        self.users.append(user)
                    }
                }
                DispatchQueue.main.async {
                    self.filteredUsers = self.users // Initialize filtered users
                    self.searchResults.reloadData()
                }
            }
        })
    }
}


extension SearchViewController {

    func addTapGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        searchResults.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {

        let touchPoint = gestureRecognizer.location(in: self.searchResults)
        if let indexPath = searchResults.indexPathForRow(at: touchPoint) {

        }
        
    }
    
    func presentDeleteActionSheet(forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this item?", preferredStyle: .actionSheet)
        present(alert, animated: true, completion: nil)
    }
    
//    func populateUserDetails(forRowAt indexPath: IndexPath) {
//        let selectedUser = filteredUsers[indexPath.row]
//        print("selected user is \(selectedUser.email)")
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let userDetailVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsID") as? UserDetailsViewController {
//            userDetailVC.user = selectedUser
//            
//            // Set the modal presentation style
//            userDetailVC.modalPresentationStyle = .pageSheet
//            
//            if let sheet = userDetailVC.sheetPresentationController {
//                // Set the preferred content size
//                sheet.detents = [.medium()] // Medium covers roughly half the screen
//                sheet.prefersGrabberVisible = true // Optional: Shows a grabber at the top of the sheet
//            }
//            
//            self.present(userDetailVC, animated: true)
//        } else {
//            print("Error: Could not instantiate UserDetailsViewController")
//        }
//    }
}

