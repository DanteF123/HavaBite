import Foundation
import FirebaseAuth
import Firebase

class UserSession {
    static let shared = UserSession()
    
    var loggedInUser: User? // A property to store the logged-in user
    let currentUser = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    private init() {
        // Lazy initialization for friends, fetched asynchronously
        lazy var friends: Set<String> = {
            var friendSet: Set<String> = []
            getUserFriends { fetchedFriends in
                friendSet = fetchedFriends
            }
            return friendSet
        }()
        
        let docRef = db.collection("users").document(currentUser!.uid)
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
            } else if let document = document, document.exists {
                let data = document.data()
                print("Document data: \(data ?? [:])")
                
                let useremail = data?["email"] as? String ?? "No email"
                let userfirstName = data?["first_name"] as? String ?? "No first name"
                let userlastName = data?["last_name"] as? String ?? "No last name"
                
                self.loggedInUser = User(first_name: userfirstName, last_name: userlastName, email: useremail, id: self.currentUser!.uid)
                
            } else {
                print("Document does not exist")
            }
        }
        

    }
    
    // Get a list of the logged in user's friends.
    // Use a completion handler to handle the asynchronous fetching of friends
    func getUserFriends(completion: @escaping (Set<String>) -> Void) {
        var friendSet: Set<String> = []
        guard let userId = currentUser?.uid else {
            print("User not logged in")
            completion(friendSet)
            return
        }
        
        let friendsRef = db.collection("users").document(userId).collection("users")
        
        friendsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting friends: \(error)")
                completion(friendSet) // Return empty set in case of error
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    friendSet.insert(id)
                }
                completion(friendSet) // Return the populated set
            }
        }
    }
    
}
