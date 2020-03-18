//
//  Ticket.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/17/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//
import Foundation

protocol Identification {
    var id: String { get }
}

// MARK: - Ticket
struct Ticket: Codable {
    let embedded: TicketEmbedded

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

// MARK: - TicketEmbedded
struct TicketEmbedded: Codable {
    let events: [Event]

    enum CodingKeys: String, CodingKey {
        case events = "events"
    }
}

// MARK: - Event
struct Event: Codable, Identification {
    let name: String
    let type: String
    let id: String
    let test: Bool
    let url: String?
    let locale: String
    let images: [TicketImage]
    let dates: Dates
    let info: String?
    let priceRanges: [PriceRange]?
    let products: [Product]?
    let seatmap: Seatmap?
    let links: EventLinks
    let embedded: EventEmbedded
    let pleaseNote: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case type = "type"
        case id = "id"
        case test = "test"
        case url = "url"
        case locale = "locale"
        case images = "images"
        case dates = "dates"
        case info = "info"
        case priceRanges = "priceRanges"
        case products = "products"
        case seatmap = "seatmap"
        case links = "_links"
        case embedded = "_embedded"
        case pleaseNote = "pleaseNote"
    }
}


// MARK: - Dates
struct Dates: Codable {
    let start: Start
    let timezone: String?
    let status: Status
    let spanMultipleDays: Bool

    enum CodingKeys: String, CodingKey {
        case start = "start"
        case timezone = "timezone"
        case status = "status"
        case spanMultipleDays = "spanMultipleDays"
    }
}

// MARK: - Start
struct Start: Codable {
    let localDate: String
    let localTime: String
    let dateTime: String
    let dateTBD: Bool
    let dateTBA: Bool
    let timeTBA: Bool
    let noSpecificTime: Bool

    enum CodingKeys: String, CodingKey {
        case localDate = "localDate"
        case localTime = "localTime"
        case dateTime = "dateTime"
        case dateTBD = "dateTBD"
        case dateTBA = "dateTBA"
        case timeTBA = "timeTBA"
        case noSpecificTime = "noSpecificTime"
    }
}

// MARK: - Status
struct Status: Codable {
    let code: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
    }
}

// MARK: - EventEmbedded
struct EventEmbedded: Codable {
    let venues: [Venue]
    let attractions: [Attraction]?

    enum CodingKeys: String, CodingKey {
        case venues = "venues"
        case attractions = "attractions"
    }
}

// MARK: - Attraction
struct Attraction: Codable {
    let name: String
    let type: String
    let id: String
    let test: Bool
    let url: String
    let locale: String
    let externalLinks: ExternalLinks?
    let images: [TicketImage]
    let upcomingEvents: UpcomingEvents
    let links: AttractionLinks

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case type = "type"
        case id = "id"
        case test = "test"
        case url = "url"
        case locale = "locale"
        case externalLinks = "externalLinks"
        case images = "images"
        case upcomingEvents = "upcomingEvents"
        case links = "_links"
    }
}

// MARK: - ExternalLinks
struct ExternalLinks: Codable {
    let youtube: [Facebook]?
    let twitter: [Facebook]?
    let itunes: [Facebook]?
    let facebook: [Facebook]?
    let instagram: [Facebook]?
    let musicbrainz: [Musicbrainz]?
    let homepage: [Facebook]?
    let wiki: [Facebook]?

    enum CodingKeys: String, CodingKey {
        case youtube = "youtube"
        case twitter = "twitter"
        case itunes = "itunes"
        case facebook = "facebook"
        case instagram = "instagram"
        case musicbrainz = "musicbrainz"
        case homepage = "homepage"
        case wiki = "wiki"
    }
}

// MARK: - Facebook
struct Facebook: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

// MARK: - Musicbrainz
struct Musicbrainz: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}

// MARK: - Image
struct TicketImage: Codable {
    let ratio: String?
    let url: String
    let width: Int
    let height: Int
    let fallback: Bool

    enum CodingKeys: String, CodingKey {
        case ratio = "ratio"
        case url = "url"
        case width = "width"
        case height = "height"
        case fallback = "fallback"
    }
}

// MARK: - AttractionLinks
struct AttractionLinks: Codable {
    let linksSelf: First

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - First
struct First: Codable {
    let href: String

    enum CodingKeys: String, CodingKey {
        case href = "href"
    }
}

// MARK: - UpcomingEvents
struct UpcomingEvents: Codable {
    let total: Int
    let ticketmaster: Int?

    enum CodingKeys: String, CodingKey {
        case total = "_total"
        case ticketmaster = "ticketmaster"
    }
}

// MARK: - Venue
struct Venue: Codable {
    let name: String
    let type: String
    let id: String
    let test: Bool
    let url: String?
    let locale: String
    let images: [TicketImage]?
    let postalCode: String
    let timezone: String
    let city: City
    let country: Country
    let address: Address
    let location: Location
    let dmas: [DMA]
    let upcomingEvents: UpcomingEvents
    let links: AttractionLinks

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case type = "type"
        case id = "id"
        case test = "test"
        case url = "url"
        case locale = "locale"
        case images = "images"
        case postalCode = "postalCode"
        case timezone = "timezone"
        case city = "city"
        case country = "country"
        case address = "address"
        case location = "location"
        case dmas = "dmas"
        case upcomingEvents = "upcomingEvents"
        case links = "_links"
    }
}

// MARK: - Address
struct Address: Codable {
    let line1: String

    enum CodingKeys: String, CodingKey {
        case line1 = "line1"
    }
}

// MARK: - BoxOfficeInfo
struct BoxOfficeInfo: Codable {
    let phoneNumberDetail: String
    let openHoursDetail: String
    let acceptedPaymentDetail: String
    let willCallDetail: String

    enum CodingKeys: String, CodingKey {
        case phoneNumberDetail = "phoneNumberDetail"
        case openHoursDetail = "openHoursDetail"
        case acceptedPaymentDetail = "acceptedPaymentDetail"
        case willCallDetail = "willCallDetail"
    }
}

// MARK: - City
struct City: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

// MARK: - Country
struct Country: Codable {
    let name: String
    let countryCode: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case countryCode = "countryCode"
    }
}

// MARK: - DMA
struct DMA: Codable {
    let id: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}

// MARK: - GeneralInfo
struct GeneralInfo: Codable {
    let generalRule: String
    let childRule: String

    enum CodingKeys: String, CodingKey {
        case generalRule = "generalRule"
        case childRule = "childRule"
    }
}

// MARK: - Location
struct Location: Codable {
    let longitude: String
    let latitude: String

    enum CodingKeys: String, CodingKey {
        case longitude = "longitude"
        case latitude = "latitude"
    }
}

// MARK: - EventLinks
struct EventLinks: Codable {
    let linksSelf: First
    let attractions: [First]?
    let venues: [First]

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case attractions = "attractions"
        case venues = "venues"
    }
}

// MARK: - PriceRange
struct PriceRange: Codable {
    let type: String
    let currency: String
    let min: Double
    let max: Double

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case currency = "currency"
        case min = "min"
        case max = "max"
    }
}

// MARK: - Product
struct Product: Codable {
    let id: String
    let url: String
    let type: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case type = "type"
        case name = "name"
    }
}

// MARK: - Promoter
struct Promoter: Codable {
    let id: String
    let name: String
    let promoterDescription: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case promoterDescription = "description"
    }
}

// MARK: - Seatmap
struct Seatmap: Codable {
    let staticURL: String

    enum CodingKeys: String, CodingKey {
        case staticURL = "staticUrl"
    }
}
