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
    
    func testUpdateUserExperience() {
        let experience = APIExperience.rijksMuseum.rawValue
        let exp = XCTestExpectation(description: "ok")
        
        FirestoreSession.session.updateDatabaseUser(experience) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(let bool):
                XCTAssertTrue(bool)
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 2)
    }
    
    func testTicketAPI() {
        let url = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(Secret.ticketKey)&city=brooklyn"
        var events = [Event]()
        let exp = XCTestExpectation()
        
        GenericCoderAPI.manager.getJSON(objectType: Ticket.self, with: url) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
                print()
                print(error.description.contains("""
keyNotFound(CodingKeys(stringValue: "_embedded", intValue: nil), Swift.DecodingError.Context(codingPath: [], debugDescription: "No value associated with key CodingKeys(stringValue: \"_embedded\", intValue: nil) (\"_embedded\").", underlyingError: nil))
"""))
                print()
                print(error.description)
                print()
            case .success(let wrapper):
                events = wrapper.embedded.events
                XCTAssertTrue(events.count > 0)
                print()
                print(events.count)
                print()
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 2)
    }
    
    func testRijkAPI() {
        let url = "https://www.rijksmuseum.nl/api/nl/collection?key=\(Secret.rijksKey)&culture=en&imgonly=True&q=city"
        var objects = [ArtObject]()
        let exp = XCTestExpectation()
        
        GenericCoderAPI.manager.getJSON(objectType: Art.self, with: url) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(let art):
                XCTAssertEqual(art.count, objects.count)
                objects = art.artObjects
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 2)
    }

}
