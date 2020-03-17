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
    
    public func createDatabaseUser (authDataResult: AuthDataResult,
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
    
}
