//
//  AuthServices.swift
//  FairFare
//
//  Created by Daru Bagus Dananjaya on 31/08/24.
//

import Foundation
import FirebaseAuth

class AuthServices {
    static func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let firebaseUser = authResult?.user {
                let user = User(firebaseUser: firebaseUser)
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])))
            }
        }
    }

    static func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let firebaseUser = authResult?.user {
                let user = User(firebaseUser: firebaseUser)
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])))
            }
        }
    }
    
    static func getCurrentUser() -> User? {
        if let firebaseUser = Auth.auth().currentUser {
            return User(firebaseUser: firebaseUser)
        }
        return nil
    }
    
    static func signOut() throws {
        try Auth.auth().signOut()
    }
}


