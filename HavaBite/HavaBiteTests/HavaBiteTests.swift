//
//  HavaBiteTests.swift
//  HavaBiteTests
//
//  Created by Dante Fusaro on 9/2/24.
//

import XCTest
@testable import HavaBite
import FirebaseAuth
import FirebaseFirestore

final class HavaBiteTests: XCTestCase {
    
    var registerVC : RegisterViewController!
    var welcomeVC : WelcomeViewController!
    var mainVC : MainViewController!
    var searchVC : SearchViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        registerVC = RegisterViewController()
        _ = registerVC.view  // Ensure that viewDidLoad is called
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        registerVC = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: T-1
    
    //TC-1
    func testSignUpWithNil() throws {
        let result = registerVC.register(firstName: "", lastName: "", email: "", password: ""){success in if success{print("success")}}
        XCTAssertFalse(result)
    }
    
    //TC-2
    func testSignUpHappyPath() throws {
        let result = registerVC.register(firstName: "user1", lastName: "user1", email: "user1@email.com", password: "123456"){success in if success{print("success")}}
        XCTAssertTrue(result)
    }
    
    //TC-2
    func testAsyncSignUpSuccess() throws {
        // Use XCTestExpectation for async code
        let expectation = self.expectation(description: "Sign Up Success")

        // Simulate user registration with valid input
        let result = registerVC.register(firstName: "user2", lastName: "user2", email: "user2@email.com", password: "123456"){success in if success{print("success")}}
        
        // Assert that the registration result is true (synchronous part)
        XCTAssertTrue(result)

        // Wait for the asynchronous operation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Additional assertions can be added here to check UI behavior
            expectation.fulfill()  // Mark expectation as fulfilled when async code completes
        }

        // Wait for expectations for a maximum of 5 seconds
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //TC-2
    func testAsyncSignUpFailure() throws {
        let expectation = self.expectation(description: "Sign Up Failure")

        // Simulate user registration with missing input
        let result = registerVC.register(firstName: "", lastName: "", email: "", password: "123456"){success in if success{print("success")}}
        
        // Assert that the registration result is false (synchronous part)
        XCTAssertFalse(result)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Additional assertions can be added here to check UI behavior
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: T-2
    
    //TC-4
    func testLogInFailure() throws {
        // Initialize the WelcomeViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController

        // Load the view to ensure the IBOutlets are connected
        welcomeVC.loadViewIfNeeded()

        // Create an expectation
        let expectation = self.expectation(description: "Login should fail due to empty email and password")
        
        // Perform the test
        welcomeVC.logIn(email: "", password: "") { success in
            // Assert that the login did not succeed
            XCTAssertFalse(success)
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    //TC-5
    func testLogInSuccess() throws {
        // Initialize the WelcomeViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController

        // Load the view to ensure the IBOutlets are connected
        welcomeVC.loadViewIfNeeded()

        // Create an expectation
        let expectation = self.expectation(description: "Login should succeed with valid email and password")
        
        // Perform the test
        welcomeVC.logIn(email: "x@x.com", password: "123456") { success in
            // Assert that the login succeeded
            XCTAssertTrue(success)
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    //MARK: T-3
    //TC-7
    
    func testSearchUser() throws {
        // Initialize the SearchViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        searchVC.loadViewIfNeeded()
        
        // Simulate data fetching by adding mock users to the users array
        let mockUsers = [
            User(first_name: "John", last_name: "Doe", email: "john@example.com", id: "1"),
            User(first_name: "Alice", last_name: "Smith", email: "alice@example.com", id: "2"),
            User(first_name: "Test", last_name: "User", email: "a@a.com", id: "3")
        ]
        
        searchVC.users = mockUsers
        searchVC.filteredUsers = mockUsers // Initialize filteredUsers with the full list of users
        
        // Call the filterUsers method to filter users by email
        searchVC.filterUsers(for: "a@a.com")
        
        // Assert that only 1 user matches the search criteria
        XCTAssertEqual(searchVC.filteredUsers.count, 1)
        XCTAssertEqual(searchVC.filteredUsers.first?.email, "a@a.com", "The filtered user should have the email 'a@a.com'")
    }
    
    
    //TC-8
    
    func testSearchInvalidUser() throws {
        // Initialize the SearchViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        searchVC.loadViewIfNeeded()
        
        // Simulate data fetching by adding mock users to the users array
        let mockUsers = [
            User(first_name: "John", last_name: "Doe", email: "john@example.com", id: "1"),
            User(first_name: "Alice", last_name: "Smith", email: "alice@example.com", id: "2"),
            User(first_name: "Test", last_name: "User", email: "a@a.com", id: "3")
        ]
        
        searchVC.users = mockUsers
        searchVC.filteredUsers = mockUsers // Initialize filteredUsers with the full list of users
        
        // Call the filterUsers method to filter users by email
        searchVC.filterUsers(for: "abc@x.com")
        
        // Assert that only 1 user matches the search criteria
        XCTAssertEqual(searchVC.filteredUsers.count, 0)
    }
    
    //TC-9
    func testSearchCurrentUser() throws {
        // Initialize the WelcomeViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        welcomeVC.loadViewIfNeeded()
        
        // Expectation to wait for the login to complete
        let loginExpectation = expectation(description: "Login completes successfully")
        
        // Perform login
        Auth.auth().signIn(withEmail: "x@x.com", password: "123456") { authResult, error in
            loginExpectation.fulfill() // Fulfill expectation after login completes
        }
        
        // Wait for the login process to complete
        wait(for: [loginExpectation], timeout: 10)
        
        // Now move on to testing the SearchViewController
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchVC.loadViewIfNeeded()
        
        // Expectation to wait for Firebase to fetch all users
        let fetchUsersExpectation = expectation(description: "Fetch users completes successfully")
        
        // Modify the getAllUsers() method to fulfill the expectation
        searchVC.getAllUsers()
        
        // Add a listener to Firestore data fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // Arbitrary delay to simulate waiting for Firestore
            fetchUsersExpectation.fulfill()
        }
        
        // Wait for the getAllUsers process to complete
        wait(for: [fetchUsersExpectation], timeout: 10)
        
        // Assert that users have been fetched and the current user is not present in the list
        print("Fetched users: \(searchVC.users)")
        XCTAssertFalse(searchVC.users.contains(where: { $0.email == "x@x.com" }), "Current user should not be in the users array")
    }
    
    
    //MARK: T-4
    //TC-10
    func testLogOutSuccess() throws {
        //Log in
        // Initialize the WelcomeViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
        welcomeVC.loadViewIfNeeded()
        
        // Expectation to wait for the login to complete
        let loginExpectation = expectation(description: "Login completes successfully")
        
        // Perform login
        Auth.auth().signIn(withEmail: "dante@email.com", password: "123456") { authResult, error in
            loginExpectation.fulfill() // Fulfill expectation after login completes
        }
        
        // Wait for the login process to complete
        wait(for: [loginExpectation], timeout: 10)
        
        // Now test the sign out process
        let mainVC = MainViewController()  // Initialize MainViewController
        
        // Perform sign out
        mainVC.signOutUser()
        
        // Assert the user is signed out
        XCTAssertNil(Auth.auth().currentUser, "User should be signed out")
        
    }
    
    //MARK: T-5
    //TC-13
    func testAddFriendSuccess() throws {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userDetailsVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsID") as! UserDetailsViewController
        // Initialize Firestore and make sure Firebase app is set up for testing
        let firestore = Firestore.firestore()

        // Simulate the current user session and user to be added
        UserSession.shared.friends = []
        UserSession.shared.loggedInUser = User(first_name: "Test", last_name: "User", email: "test@example.com", id: "12345")
        
        let friendUser = User(first_name: "New", last_name: "Friend", email: "newfriend@example.com", id: "67890")
        
        // Set the user in UserDetailsViewController
        userDetailsVC.user = friendUser

        // Create an expectation for asynchronous test
        let expectation = self.expectation(description: "Friend added to Firestore and UserSession")
        
        // Call the addFriend method
        userDetailsVC.addFriend()
        
        // Wait asynchronously for Firestore to update and the friends list to be updated
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Verify friend was added to the UserSession
            XCTAssertTrue(UserSession.shared.friends.contains(friendUser.id), "Friend should be added to UserSession's friends")
            
            // Fulfill the expectation
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //TC-14
    func testAddFriendAlreadyExists() throws {
        // Initialize UserDetailsViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userDetailsVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsID") as! UserDetailsViewController

        // Simulate a current user and a friend in the session
        UserSession.shared.loggedInUser = User(first_name: "Test", last_name: "User", email: "x@x.com", id: "ylMyU53PewXExHvt1Hwfh6yzvsm1")
        
        // Set a test user (friend) to add, who is already in the friends list
        let existingFriend = User(first_name: "John", last_name: "Doe", email: "a@a.com", id: "29LhewfEQKWfwPJHDqAlDcCANbs2")
        userDetailsVC.user = existingFriend
        
        // Load the view to ensure the IBOutlets are connected
        userDetailsVC.loadViewIfNeeded()
        
        // Precondition: Add the friend to UserSession's friends list
        UserSession.shared.friends.insert(existingFriend.id)

        // Verify that the friend was added in precondition
        XCTAssertTrue(UserSession.shared.friends.contains(existingFriend.id), "Friend should already be in the user's friends list")


    }
    
    //TC-15
    func testUserAddedinBackend() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userDetailsVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsID") as! UserDetailsViewController
        let mockUser = User(first_name: "Test", last_name: "User", email: "test@example.com", id: "ylMyU53PewXExHvt1Hwfh6yzvsm1")
        UserSession.shared.loggedInUser = mockUser
        
        let newFriend = User(first_name: "John", last_name: "Doe", email: "john@example.com", id: "friendId123")
        userDetailsVC.user = newFriend
        
        // Precondition: Ensure friend is not in UserSession.shared.friends before starting
        XCTAssertFalse(UserSession.shared.friends.contains(newFriend.id), "Friend should not be in UserSession initially")
        
        // Create an expectation for Firebase write and query completion
        let expectation = self.expectation(description: "Friend should be added to Firebase and available in Firestore")

        // Call addFriend method to add the friend locally and remotely
        userDetailsVC.addFriend()

        // Delay to give time for Firestore write to complete (normally takes <1 second)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Query Firestore directly to check if the friend was added
            let db = Firestore.firestore()
            let friendsRef = db.collection("users").document(UserSession.shared.loggedInUser!.id).collection("users").document(newFriend.id)

            friendsRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Assert that the document contains the correct data
                    let data = document.data()
                    XCTAssertEqual(data?["email"] as? String, newFriend.email, "Email should match")
                    XCTAssertEqual(data?["first_name"] as? String, newFriend.first_name, "First name should match")
                    XCTAssertEqual(data?["last_name"] as? String, newFriend.last_name, "Last name should match")

                    // Friend added successfully, fulfill the expectation
                    expectation.fulfill()
                } else {
                    XCTFail("Friend was not added to Firestore")
                }
            }
        }

        // Wait for the expectations to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: T-6
    //TC-16
    
    func testUserFriendList() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let friendsVC = storyboard.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
        welcomeVC.loadViewIfNeeded()
        
        // Create an expectation for the login process to complete
        let loginExpectation = expectation(description: "Login completes successfully")
        
        // Perform login
        Auth.auth().signIn(withEmail: "a@a.com", password: "123456") { authResult, error in
            if let authResult = authResult {
                // After login, initialize the UserSession with the logged-in user
                UserSession.shared.initializeLoggedInUser(with: authResult.user) {
                    // Fulfill the expectation once friends are fetched
                    loginExpectation.fulfill()
                }
            } else {
                XCTFail("Login failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        // Wait for the login process and friends fetching to complete
        wait(for: [loginExpectation], timeout: 10)
        
        // Now, check the friend count after Firestore has finished fetching
        let friendSize = UserSession.shared.friends.count
        
        // Load the FriendsViewController's view
        friendsVC.loadViewIfNeeded()
        
        // Create an expectation for populateFriends to complete
        let populateFriendsExpectation = expectation(description: "Friends are populated from Firestore")
        
        // Call populateFriends and wait for completion
        friendsVC.populateFriends { [weak self] users, error in
            if let error = error {
                XCTFail("Error populating friends: \(error)")
            } else {
                populateFriendsExpectation.fulfill() // Fulfill the expectation once friends are populated
            }
        }
        
        // Wait for friends to be populated
        wait(for: [populateFriendsExpectation], timeout: 10)
        
        // Now that friends are populated, check the table size
        let tableSize = friendsVC.friends.count
        print("Friend count in UserSession: \(friendSize)")
        print("Friend count in tableView: \(tableSize)")
        
        // Assert that the friend count in UserSession matches the count in FriendsViewController's array
        XCTAssertEqual(friendSize, tableSize, "Friend count in UserSession should match friend count in tableView")
    }
    
    //MARK: T-7
    //TC-19
    func testRemoveFriend() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let friendsVC = storyboard.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
        
        // Load the view to ensure outlets and other properties are connected
        friendsVC.loadViewIfNeeded()
        
        // Simulate the current user's session and friends
        UserSession.shared.loggedInUser = User(first_name: "Test", last_name: "User", email: "test@example.com", id: "currentUserId1")
        
        // Add a test friend to the friends array
        let friend = User(first_name: "John", last_name: "Doe", email: "john@example.com", id: "friendId123")
        friendsVC.friends = [friend]
        
        // Reload the table to reflect the new friend
        friendsVC.friendsList.reloadData()
        
        // Ensure the friend list contains one friend before removal
        XCTAssertEqual(friendsVC.friends.count, 1, "Friend list should contain 1 friend initially")
        
        // Create an expectation for the asynchronous removal
        let removeFriendExpectation = expectation(description: "Friend should be removed")
        
        // Get the first cell and simulate tapping the remove button
        let cell = friendsVC.friendsList.cellForRow(at: IndexPath(row: 0, section: 0)) as! FriendCell
        
        // Call the delegate method to simulate the remove button tap
        friendsVC.didTapRemoveButton(on: cell)
        
        // Wait for the Firebase operation to complete (simulate by using async delay or Firebase completion handler)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Ensure the friend was removed from the friends array
            XCTAssertEqual(friendsVC.friends.count, 0, "Friend list should be empty after removal")
            
            // Fulfill the expectation
            removeFriendExpectation.fulfill()
        }
        
        // Wait for expectations with a timeout
        wait(for: [removeFriendExpectation], timeout: 5.0)
    }
    
    //TC-20
    func testRemoveFriendBackend() throws {
        let db = Firestore.firestore()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let friendsVC = storyboard.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
        
        // Load the view to ensure outlets and other properties are connected
        friendsVC.loadViewIfNeeded()
        
        // Simulate the current user's session and friends
        UserSession.shared.loggedInUser = User(first_name: "Test", last_name: "User", email: "test@example.com", id: "currentUserId2")
        
        // Add a test friend to the friends array
        let friend = User(first_name: "John", last_name: "Doe", email: "john@example.com", id: "friendId123")
        friendsVC.friends = [friend]
        
        // Reload the table to reflect the new friend
        friendsVC.friendsList.reloadData()
        
        // Ensure the friend list contains one friend before removal
        XCTAssertEqual(friendsVC.friends.count, 1, "Friend list should contain 1 friend initially")
        
        // Create an expectation for the asynchronous removal
        let removeFriendExpectation = expectation(description: "Friend should be removed from local list")
        let firestoreCheckExpectation = expectation(description: "Friend should be removed from Firestore")
        
        // Get the first cell and simulate tapping the remove button
        let cell = friendsVC.friendsList.cellForRow(at: IndexPath(row: 0, section: 0)) as! FriendCell
        
        // Call the delegate method to simulate the remove button tap
        friendsVC.didTapRemoveButton(on: cell)
        
        // Wait for the Firebase operation to complete (simulate by using async delay or Firebase completion handler)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Fulfill the expectation for local list removal
            removeFriendExpectation.fulfill()
        }
        
// Firestore Query: Check if the friend was removed from Firestore
       let userId = UserSession.shared.loggedInUser!.id
       let friendsRef = db.collection("users").document(userId).collection("users").document("friendId123")
       
       // Query Firestore to ensure the friend's document is deleted
       friendsRef.getDocument { (document, error) in
           if let document = document, document.exists {
               XCTFail("Friend document still exists in Firestore after removal")
           } else {
               // Friend was successfully removed from Firestore
               firestoreCheckExpectation.fulfill()
           }
       }
        
        // Wait for both expectations with a timeout
        wait(for: [removeFriendExpectation, firestoreCheckExpectation], timeout: 5.0)
        
    }
}
