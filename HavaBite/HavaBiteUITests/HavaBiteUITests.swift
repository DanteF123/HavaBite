//
//  HavaBiteUITests.swift
//  HavaBiteUITests
//
//  Created by Dante Fusaro on 9/2/24.
//

import XCTest

final class HavaBiteUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    //MARK: T-1
    //TC-3
    
    func testRegisterButtonClick() {
        // Launch the app
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to RegisterViewController (simulate tapping the button)
        let goToRegisterButton = app.buttons["signupButton"] // Button that triggers the navigation
        XCTAssertTrue(goToRegisterButton.exists, "The button to navigate to Register should exist")
        goToRegisterButton.tap()

        // Wait for the RegisterViewController to appear
        let registerButton = app.buttons["registerButton"]
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: registerButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        // Tap outside the text field to dismiss the keyboard
        let backgroundElement = app.otherElements["registerBackgroundView"] // Replace with an actual accessible element
        
        
        // Fill the text fields
        let firstNameTextField = app.textFields["registerFirstnameText"]
        firstNameTextField.tap()
        firstNameTextField.typeText("John")
        backgroundElement.tap()

        let lastNameTextField = app.textFields["registerLastnameText"]
        lastNameTextField.tap()
        lastNameTextField.typeText("Doe")
        backgroundElement.tap()

        let emailTextField = app.textFields["registerEmailText"]
        emailTextField.tap()
        emailTextField.typeText("john4@example.com")
        backgroundElement.tap()

        let passwordTextField = app.textFields["registerPasswordText"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        backgroundElement.tap()

        // Tap the Register button
        registerButton.tap()

        // Assert the success message appears
        let successAlert = app.alerts["Success"]
        // Use an expectation to wait for up to 5 seconds for the alert to appear
        expectation(for: exists, evaluatedWith: successAlert, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(successAlert.exists, "The success alert should appear after registration")
    }
    
    //MARK: T-2
    
    //TC-6
    func testSignInButtonClick() {
        // Launch the app
        let app = XCUIApplication()
        app.launch()

        
        let logInButton = app.buttons["logInButton"]
        // Fill the text fields

        
        let passwordTextField = app.textFields["passwordText"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        app.keyboards.buttons["Return"].tap()

        let emailTextField = app.textFields["emailText"]
        emailTextField.tap()
        emailTextField.typeText("john2@example.com")
        app.keyboards.buttons["Return"].tap()
        
        let enteredEmail = emailTextField.value as! String
        let enteredPassword = passwordTextField.value as! String

        // Tap the Register button
        logInButton.tap()
    
        XCTAssertTrue(enteredEmail != "" && enteredPassword != "", "The app should successfully track")
    }
    
    //MARK: T-3
    //MARK: T-4
    // TC 11 and 12
    
    func testSideMenuLogout() {
        let app = XCUIApplication()
        app.launch()

        // Log in
        let logInButton = app.buttons["logInButton"]

        let passwordTextField = app.textFields["passwordText"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        app.keyboards.buttons["Return"].tap()

        let emailTextField = app.textFields["emailText"]
        emailTextField.tap()
        emailTextField.typeText("john2@example.com")
        app.keyboards.buttons["Return"].tap()

        logInButton.tap()

        // Open side menu
        let sideMenuButton = app.buttons["Side Menu Button"]
        sideMenuButton.tap()

        // Find and tap the third menu item (Logout, index 2 since arrays are 0-indexed)
        let sideMenuTableView = app.tables["SideMenuTable"] // Replace with the actual accessibility identifier of your table view
        
        let thirdMenuItem = sideMenuTableView.cells.element(boundBy: 3) // Fourth menu item
        
        print(thirdMenuItem)
        XCTAssertTrue(thirdMenuItem.exists, "Third menu item should exist")
        thirdMenuItem.tap()

        // Optionally, check if the user has been logged out or redirected
        let signInButton = app.buttons["logInButton"]
        XCTAssertTrue(signInButton.exists, "The user should be logged out and back on the login screen")
    }
    
}
