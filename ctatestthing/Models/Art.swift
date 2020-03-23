//
//  Art.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/18/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import Foundation

// MARK: - Art
struct Art: Codable {
    let elapsedMilliseconds: Int
    let count: Int
    let artObjects: [ArtObject]

    enum CodingKeys: String, CodingKey {
        case elapsedMilliseconds = "elapsedMilliseconds"
        case count = "count"
        case artObjects = "artObjects"
    }
}

// MARK: - ArtObject
struct ArtObject: Codable, Identification {
    let links: Links
    let id: String
    let objectNumber: String
    let title: String
    let hasImage: Bool
    let principalOrFirstMaker: String
    let longTitle: String
    let showImage: Bool
    let permitDownload: Bool
    let webImage: Image
    let headerImage: Image
    let productionPlaces: [String]

    enum CodingKeys: String, CodingKey {
        case links = "links"
        case id = "id"
        case objectNumber = "objectNumber"
        case title = "title"
        case hasImage = "hasImage"
        case principalOrFirstMaker = "principalOrFirstMaker"
        case longTitle = "longTitle"
        case showImage = "showImage"
        case permitDownload = "permitDownload"
        case webImage = "webImage"
        case headerImage = "headerImage"
        case productionPlaces = "productionPlaces"
    }
}

// MARK: - Image
struct Image: Codable {
    let guid: String
    let offsetPercentageX: Int
    let offsetPercentageY: Int
    let width: Int
    let height: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case guid = "guid"
        case offsetPercentageX = "offsetPercentageX"
        case offsetPercentageY = "offsetPercentageY"
        case width = "width"
        case height = "height"
        case url = "url"
    }
}

// MARK: - Links
struct Links: Codable {
    let linksSelf: String
    let web: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case web = "web"
    }
}
