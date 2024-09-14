//
//  HavaBiteTests.swift
//  HavaBiteTests
//
//  Created by Dante Fusaro on 9/2/24.
//

import XCTest
@testable import HavaBite

final class HavaBiteTests: XCTestCase {
    
    var registerVC : RegisterViewController!

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
    
    func testSignUpWithoutName() throws {
        let result = registerVC.register(firstName: "", lastName: "", email: "email@email.com", password: "123456")
        XCTAssertFalse(result)
    }

    func testSignUpHappyPath() throws {
        let result = registerVC.register(firstName: "user1", lastName: "user1", email: "user1@email.com", password: "123456")
        XCTAssertTrue(result)
    }
    
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
    
    
}
