//
//  ctatestthingTests.swift
//  ctatestthingTests
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import XCTest
import FirebaseAuth
@testable import ctatestthing

class ctatestthingTests: XCTestCase {

    func testLOGOUT() {
        try? Auth.auth().signOut()
    }
    
    func testValidateExperience() {
        var experience: String? = nil
        let exp = XCTestExpectation(description: "sure")
        
        FirestoreSession.session.getUserExperience { result in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(let str):
                experience = str
                XCTAssertNotNil(experience)
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 2)
    }
    
    func updateUserExperience() {
        
    }

}
