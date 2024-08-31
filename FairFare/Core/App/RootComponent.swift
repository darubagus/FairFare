//
//  RootComponent.swift
//  FairFare
//
//  Created by Daru Bagus Dananjaya on 31/08/24.
//

import Foundation
import Firebase

protocol FirebaseServiceProtocol {
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
//    func saveBill(_ bill: Bill, completion: @escaping (Result<Void, Error>) -> Void)
//    func getBills(for userID: String, completion: @escaping (Result<[Bill], Error>) -> Void)
//    func saveProfile(_ profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void)
//    func getProfile(for userID: String, completion: @escaping (Result<UserProfile, Error>) -> Void)
}

class FirebaseService: FirebaseServiceProtocol {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
