import Foundation
import FirebaseAuth
import Firebase

class UserSession {
    static let shared = UserSession()
    
    var loggedInUser: User? // A property to store the logged-in user
    var friends: Set<String> = [] // A set to store the logged-in user's friends
    let db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    
    private init() {}
    
    // Initialize the logged-in user and fetch friends from Firestore
    func initializeLoggedInUser(with firebaseUser: FirebaseAuth.User, completion: @escaping () -> Void) {
        currentUser = Auth.auth().currentUser
        let userId = firebaseUser.uid
        let docRef = db.collection("users").document(userId)
        
        // Fetch user details
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                completion() // Call completion even on error
            } else if let document = document, document.exists {
                let data = document.data()
                let userEmail = data?["email"] as? String ?? "No email"
                let userFirstName = data?["first_name"] as? String ?? "No first name"
                let userLastName = data?["last_name"] as? String ?? "No last name"
                
                self.loggedInUser = User(
                    first_name: userFirstName,
                    last_name: userLastName,
                    email: userEmail,
                    id: userId
                )
                
                // Now fetch the user's friends
                self.getUserFriends(userId: userId) {
                    completion() // Call the completion handler once both user and friends are fetched
                }
            } else {
                print("Document does not exist")
                completion() // Call completion if the document does not exist
            }
        }
    }
    
    // Fetch the user's friends asynchronously
    private func getUserFriends(userId: String, completion: @escaping () -> Void) {
        let friendsRef = db.collection("users").document(userId).collection("users")
        
        friendsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting friends: \(error)")
                completion() // Call completion even on error
            } else {
                var friendSet: Set<String> = []
                
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    friendSet.insert(id)
                }
                
                self.friends = friendSet // Set the friends set
                print("Friends fetched: \(friendSet)")
                completion() // Call completion once friends are fetched
            }
        }
    }
}
