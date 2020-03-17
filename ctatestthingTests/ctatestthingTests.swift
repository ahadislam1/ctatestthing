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

}
