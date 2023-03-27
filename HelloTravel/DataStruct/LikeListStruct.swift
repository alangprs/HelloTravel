//
//  LikeListStruct.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/27.
//

import Foundation

// MARK: - LikeListStructValue

/// 收集清單資料結構
struct LikeListStructValue: Codable {
    let alias: String
    let categories: [LikeListCategory]
    let coordinates: Coordinates
    let displayPhone: String
    let distance: Double
    let id: String
    let imageURL: String
    let isClosed: Bool
    let location: LikeListLocation
    let name, phone, price: String
    let rating: Double
    let reviewCount: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case alias, categories, coordinates
        case displayPhone = "display_phone"
        case distance, id
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case location, name, phone, price, rating
        case reviewCount = "review_count"
        case url
    }
}

// MARK: - Category
struct LikeListCategory: Codable {
    let alias, title: String
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct LikeListLocation: Codable {
    let address1, address2, address3, city: String
    let country: String
    let displayAddress: [String]
    let state, zipCode: String

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city, country
        case displayAddress = "display_address"
        case state
        case zipCode = "zip_code"
    }
}
