import Foundation
import FirebaseAuth
import Firebase

class UserSession {
    static let shared = UserSession()
    
    var loggedInUser: User? // A property to store the logged-in user
    var friends: Set<String> = [] // A set to store the logged-in user's friends
    let db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    var friendReviews: [String: [Int]] = [:]
    var averageReviews:[String: Double] = [:]
    
    
    private init() {}
    
    // Initialize the logged-in user and fetch friends from Firestore
    func initializeLoggedInUser(with firebaseUser: FirebaseAuth.User, completion: @escaping () -> Void) {
        currentUser = Auth.auth().currentUser
        friends.removeAll()
        friendReviews.removeAll()
        averageReviews.removeAll()
        
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
                    // Now get user's friends reivews
                    self.getReviews() {
                        completion()
                    }
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
    
    
    //fetch the reviews for each of the user's friends
    private func getReviews(completion: @escaping () -> Void) {
        let group = DispatchGroup() // To manage async tasks

        for friend in friends {
            print("Fetching reviews for friend: \(friend)")
            
            group.enter() // Enter the group for each friend's reviews
            let reviewRef = db.collection("users").document(friend).collection("reviews")
            
            reviewRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting ratings for friend \(friend): \(error)")
                } else if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        let id = document.documentID
                        if let rating = document.data()["rating"] as? Int {
                            // If the key doesn't exist, initialize an empty array
                            if self.friendReviews[id] == nil {
                                self.friendReviews[id] = []
                            }
                            
                            // Append the rating to the array for this key
                            self.friendReviews[id]?.append(rating)
                        }
                    }
                }
                
                group.leave() // Leave the group once processing is done
            }
        }
        
        group.notify(queue: .main) {
            print("All reviews fetched: \(self.friendReviews)")
            self.calculateAverageReview()
            print("review average\(self.averageReviews)")
            completion() // Call completion after all Firestore calls complete
        }
    }
    
    //Method to calculate the average review from the friendsReview Hashmap
    private func calculateAverageReview(){
        for restaurant in friendReviews{
            if !friendReviews[restaurant.key]!.isEmpty{
                let sum = (friendReviews[restaurant.key]?.reduce(0,+))!
                let average = Double(sum) / Double(friendReviews[restaurant.key]!.count) // Calculate average
                
                // Round to one decimal place
                let roundedAverage = round(average * 10) / 10
                
                averageReviews[restaurant.key] = roundedAverage
            }
        }
    }
}
