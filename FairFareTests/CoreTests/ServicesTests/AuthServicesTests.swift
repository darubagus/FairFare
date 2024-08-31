//
//  AuthServicesTests.swift
//  FairFare
//
//  Created by Daru Bagus Dananjaya on 31/08/24.
//

import XCTest
@testable import FairFare
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

final class AuthServiceTests: XCTestCase {
    override func setUpWithError() throws {
        super.setUp()
        FirebaseApp.configure()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSignUp() throws {
        let expectation = expectation(description: "Sign up")
        
        AuthServices.signUp(email: "test@example.com", password: "password123") { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.email, "test@example.com")
                XCTAssertNotNil(user.id)
            case .failure(let error):
                XCTFail("Sign up failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func testSignIn() throws {
        let expectation = expectation(description: "Sign in")
        
        AuthServices.signIn(email: "test@example.com", password: "password123") { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.email, "test@example.com")
                XCTAssertNotNil(user.id)
            case .failure(let error):
                XCTFail("Sign in failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func testGetCurrentUser() throws {
        // This test assumes a user is already signed in
        let user = AuthServices.getCurrentUser()
        XCTAssertNotNil(user)
        XCTAssertNotNil(user?.id)
        XCTAssertNotNil(user?.email)
    }
        
    func testSignOut() throws {
        try AuthServices.signOut()
        XCTAssertNil(AuthService.getCurrentUser())
    }
}
