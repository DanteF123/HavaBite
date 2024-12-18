//
//  FriendsViewController.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/6/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FriendsViewController: UIViewController, UITableViewDataSource {
    

    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var friendsList: UITableView!
    
    var friends: [User] = []
    let db = Firestore.firestore()
    let currentUser = UserSession.shared.currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adjusting cell color to match design philosophy
        friendsList.backgroundColor = #colorLiteral(red: 0.5989779234, green: 0.825442493, blue: 0.8293678164, alpha: 1)
        friendsList.dataSource = self
        
        //register cell
        self.friendsList.register(FriendCell.nib, forCellReuseIdentifier: FriendCell.identifier)
        
        addTapGestureRecognizer()
        
        populateFriends { [weak self] users, error in
            if let error = error {
                print("Error populating friends: \(error)")
            } else {
                // Reload the table view after updating friends list
                self?.friendsList.reloadData()
            }
        }
        
        sideMenuButton.target = revealViewController()
        sideMenuButton.action = #selector(revealViewController()?.revealSideMenu)
        
    }

}

extension FriendsViewController: FriendCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    //Assigning data to cell for table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listItem = friends[indexPath.row].email
        
        guard let cell = friendsList.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell else { fatalError("xib does not exist")
        }
        
        cell.userEmail.text = listItem
        cell.delegate = self  // Set the delegate to FriendsViewController
        
        return cell
    }
    
    //Handling logic if the user taps the remove button on the friend's modal.
    func didTapRemoveButton(on cell: FriendCell) {
        print("Button clicked")
        // Remove friend from Firestore
        guard let indexPath = friendsList.indexPath(for: cell) else { return }
        let friendToRemove = friends[indexPath.row]
        
        // Remove friend from Firestore
        removeFriend(friendToRemove) { [weak self] success in
            if success {
                // If removal is successful, update the local array and table view
                self?.friends.remove(at: indexPath.row)
                self?.friendsList.deleteRows(at: [indexPath], with: .automatic)
                UserSession.shared.friends.remove(friendToRemove.id)
                
            } else {
                // Print failure
                print("Failed to remove friend.")
            }
        }
        //Reload the data so the list is updated visually.
        friendsList.reloadData()
    }
    
    //Method to handle removal by deleting the corresponding document from the backend.
    private func removeFriend(_ friend: User, completion: @escaping (Bool) -> Void) {

        db.collection("users").document(currentUser!.uid).collection("users").document(friend.id).delete { error in
            if let error = error {
                print("Error removing friend: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
}


extension FriendsViewController{
    
    func populateFriends(completion: @escaping ([String]?, Error?) -> Void) {
        let userIds = Array(UserSession.shared.friends)
        print("Fetching friends with IDs: \(userIds)") // Debug statement

        // Ensure the userIds array is not empty
        guard !userIds.isEmpty else {
            completion([], nil)
            return
        }

        // Query Firestore for documents where the document ID is in the userIds array
        db.collection("users").whereField(FieldPath.documentID(), in: userIds).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                // Handle the error
                print("Error fetching documents: \(error)") // Debug statement
                completion(nil, error)
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No documents found.") // Debug statement
                completion([], nil)
                return
            }

            // Clear the existing friends list before adding the new data
            self?.friends.removeAll()

            // Parse the documents into User objects
            documents.forEach { document in
                let data = document.data()
                let user_email = data["email"]
                let user_first_name = data["first_name"]
                let user_last_name = data["last_name"]
                let id = document.documentID
                
                let user = User(first_name: user_first_name as? String ?? "",
                                last_name: user_last_name as? String ?? "",
                                email: user_email as? String ?? "",
                                id: id)
                
                self?.friends.append(user)
                print("Added friend: \(user.email)") // Debug statement
            }

            // Reload the table view after updating the friends array
            self?.friendsList.reloadData()
            completion(nil, nil)
        }
    }
    
}

extension FriendsViewController{
    func addTapGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        friendsList.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {

        let touchPoint = gestureRecognizer.location(in: self.friendsList)
        if let indexPath = friendsList.indexPathForRow(at: touchPoint) {
            populateUserDetails(forRowAt: indexPath)
        }
        
    }
    
    func presentDeleteActionSheet(forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this item?", preferredStyle: .actionSheet)
        present(alert, animated: true, completion: nil)
    }
    
    func populateUserDetails(forRowAt indexPath: IndexPath) {
        let selectedUser = friends[indexPath.row]
        print("selected user is \(selectedUser.email)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let userDetailVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsID") as? UserDetailsViewController {
            userDetailVC.user = selectedUser
            
            // Set the modal presentation style
            userDetailVC.modalPresentationStyle = .pageSheet
            
            if let sheet = userDetailVC.sheetPresentationController {
                // Set the preferred content size
                sheet.detents = [.medium()] // Medium covers roughly half the screen
                sheet.prefersGrabberVisible = true // Optional: Shows a grabber at the top of the sheet
            }
            
            self.present(userDetailVC, animated: true)
        } else {
            print("Error: Could not instantiate UserDetailsViewController")
        }
    }
}
