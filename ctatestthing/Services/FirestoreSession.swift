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
import FirebaseFirestoreSwift

class FirestoreSession {
    private init() {}
    static let session = FirestoreSession()
    
    private static let usersCollection = "users"
    private static let ticketsCollection = "tickets"
    private static let artsCollection = "arts"
    
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
                } else if let documentSnapshot = documentSnapshot, documentSnapshot.exists, let data = documentSnapshot.data() {
                    let y = data["apiExperience"] as! String
                    completion(.success(y))
                }
        }
    }
    
    public func addListener(completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(FirestoreSession.usersCollection)
            .document(user.uid)
            .addSnapshotListener { (documentSnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                guard let document = documentSnapshot, let data = document.data() else {
                    return
                }
                
                completion(.success(data["apiExperience"] as! String))
                
                
        }
    }
    
    public func addListener<T: Codable>(objectType: T.Type, experience: APIExperience, completion: @escaping (Result<[T], Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        var arr = [T?]()
        
        db.collection(FirestoreSession.usersCollection)
            .document(user.uid)
            .collection(experience ==  .ticketMaster ?
                FirestoreSession.ticketsCollection : FirestoreSession.artsCollection)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    for document in snapshot.documents {
                        do {
                            let item = try document.data(as: T.self)
                            arr.append(item)
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
                
                completion(.success(arr.compactMap{$0}))
        }

        
    }
    
    
    
    public func addItem<T: Codable & Identification>(_ item: T, experience: APIExperience, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        let document = db.collection(FirestoreSession.usersCollection)
            .document(user.uid)
            .collection(experience ==  .ticketMaster ?
                FirestoreSession.ticketsCollection : FirestoreSession.artsCollection)
            .document(item.id)
        
        do {
            try document.setData(from: item)
            completion(.success(true))
        } catch let error {
            completion(.failure(error))
        }
        
    }
    
    public func deleteItem<T: Codable & Identification>(_ item: T, experience: APIExperience, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(FirestoreSession.usersCollection)
            .document(user.uid)
            .collection(experience == .ticketMaster ?
                FirestoreSession.ticketsCollection : FirestoreSession.artsCollection)
            .document(item.id)
            .delete { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
        }
    }
    
    public func isItemFavorited<T: Codable & Identification>(_ item: T, experience: APIExperience, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(FirestoreSession.usersCollection)
            .document(user.uid)
            .collection(experience == .ticketMaster ?
                FirestoreSession.ticketsCollection : FirestoreSession.artsCollection)
            .whereField("id", isEqualTo: item.id)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    snapshot.documents.count > 0 ? completion(.success(true)) : completion(.success(false))
                }
        }
        
    }
    
    public func fetchItems<T: Codable>(type: T.Type, experience: APIExperience, completion: @escaping (Result<[T], Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        var items = [T?]()
        
        db.collection(FirestoreSession.usersCollection)
            .document(user.uid)
            .collection(experience == .ticketMaster ?
                FirestoreSession.ticketsCollection : FirestoreSession.artsCollection)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    for document in snapshot.documents {
                        do {
                            let item = try document.data(as: T.self)
                            items.append(item)
                        } catch let error {
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(items.compactMap { $0 }))
                }
        }
    }
}
