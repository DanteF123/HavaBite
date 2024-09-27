//
//  HavaBiteTests.swift
//  HavaBiteTests
//
//  Created by Dante Fusaro on 9/2/24.
//

import XCTest
@testable import HavaBite
import FirebaseAuth

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
        let result = registerVC.register(firstName: "", lastName: "", email: "", password: "")
        XCTAssertFalse(result)
    }
    
    //TC-2
    func testSignUpHappyPath() throws {
        let result = registerVC.register(firstName: "user1", lastName: "user1", email: "user1@email.com", password: "123456")
        XCTAssertTrue(result)
    }
    
    //TC-2
    func testAsyncSignUpSuccess() throws {
        // Use XCTestExpectation for async code
        let expectation = self.expectation(description: "Sign Up Success")

        // Simulate user registration with valid input
        let result = registerVC.register(firstName: "user2", lastName: "user2", email: "user2@email.com", password: "123456")
        
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
        let result = registerVC.register(firstName: "", lastName: "", email: "", password: "123456")
        
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

        // Perform the test
        let result = welcomeVC.logIn(email: "", password: "")
        
        
        XCTAssertFalse(result)
    }
    
    
    //TC-5
    func testLogInSuccess() throws {
        // Initialize the WelcomeViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController

        // Load the view to ensure the IBOutlets are connected
        welcomeVC.loadViewIfNeeded()

        // Perform the test
        let result = welcomeVC.logIn(email: "dante@email.com", password: "123456")
        
        XCTAssertTrue(result)
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
        XCTAssertFalse(searchVC.users.contains(where: { $0.email == Auth.auth().currentUser?.email }), "Current user should not be in the users array")
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
    
    
}
