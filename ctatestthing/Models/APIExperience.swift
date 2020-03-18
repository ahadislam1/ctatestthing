//
//  APIExperience.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/17/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import Foundation

enum APIExperience: String, CustomStringConvertible {
    var description: String {
        self.rawValue
    }
    
    case ticketMaster = "TicketMaster"
    case rijksMuseum = "Rijksmuseum"
    
    static func toValue(_ num: Int) -> String {
        if num == 0 {
            return APIExperience.ticketMaster.rawValue
        } else {
            return APIExperience.rijksMuseum.rawValue
        }
    }
    
    
}
