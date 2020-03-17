//
//  FirestoreSession.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/17/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirestoreSession {
    private init() {}
    static let session = FirestoreSession()
    
    private static let usersCollection = "users"
    
    private let db = Firestore.firestore()
    
    public func createDatabaseUser(authDataResult: AuthDataResult,
                                    apiExperience: String,
                                    completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let email = authDataResult.user.email else {
            return
        }
        
        db.collection(FirestoreSession.usersCollection)
            .document(authDataResult.user.uid)
            .setData(["email": email,
                      "apiExperience": apiExperience,
                      "createdData": Timestamp(date: Date()),
                      "userID": authDataResult.user.uid]) {
                        error in
                        
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(true))
                        }
        }
    }
    
    public func updateDatabaseUser(_ apiExperience: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(FirestoreSession.usersCollection)
            .document(user.uid)
            .updateData(["apiExperience" : apiExperience]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
        }
    }
    
    public func getUserExperience(completion: @escaping (Result<String, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(FirestoreSession.usersCollection)
            .document(user.uid)
            .getDocument { (documentSnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                    let x = documentSnapshot.data()
                    let y = x!["apiExperience"] as! String
                    completion(.success(y))
                }
        }
    }
}
