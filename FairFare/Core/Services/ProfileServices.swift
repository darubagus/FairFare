//
//  ProfileServices.swift
//  FairFare
//
//  Created by Daru Bagus Dananjaya on 31/08/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct User: Codable {
    let id: String
    let email: String
    var displayName: String?
    var photoURL: URL?
    
    init(firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.displayName = firebaseUser.displayName
        self.photoURL = firebaseUser.photoURL
}
    
//    let uid: String
//    let email: String
//    let displayName: String?
//    let lastLogin: Date
//    let createdAt: Date
//    let id: String
//    var photoURL: URL?
//
//    init(firebaseUser: FirebaseAuth.User) {
//        self.id = firebaseUser.uid
//        self.email = firebaseUser.email ?? ""
//        self.displayName = firebaseUser.displayName
//        self.photoURL = firebaseUser.photoURL
//    }
}

class ProfileServices {
    private let db = Firestore.firestore()
    private let profilesCollection = "users"
    
    func createProfile(_ profile: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let data = try? JSONEncoder().encode(profile)
        guard let dict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {
            completion(.failure(NSError(domain: "ProfileService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode profile"])))
            return
        }
        
        db.collection(profilesCollection).document(profile.id).setData(dict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getProfile(for userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection(profilesCollection).document(userId).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "ProfileService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])))
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: document.data() ?? [:], options: [])
                let profile = try JSONDecoder().decode(User.self, from: data)
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(_ profile: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let data = try? JSONEncoder().encode(profile)
        guard let dict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {
            completion(.failure(NSError(domain: "ProfileService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode profile"])))
            return
        }
        
        db.collection(profilesCollection).document(profile.id).updateData(dict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteProfile(for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(profilesCollection).document(userId).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getCurrentUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "ProfileService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])))
            return
        }
        
        getProfile(for: currentUser.uid, completion: completion)
    }
    
    func updateProfileField(for userId: String, field: String, value: Any, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(profilesCollection).document(userId).updateData([field: value]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
