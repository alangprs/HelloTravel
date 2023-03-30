//
//  DisplayBusinessStruct.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/29.
//

import Foundation

// MARK: - SearchBusinessesStruct

/// 顯使用景點資料，提供此景點是否有被收藏
struct DisplayBusinessStruct: Codable {
    let businesses: [DisplayBusiness]
    let total: Int?
    let region: DisplayRegion
}

// MARK: - Business
struct DisplayBusiness: Codable {
    let id, alias, name: String
    let imageURL: String
    /// 是否還有營運
    let isClosed: Bool
    /// Yelp 網址
    let url: String
    /// 評論數量
    let reviewCount: Int
    /// 企業分類
    let categories: [Category]
    /// 評分
    let rating: Double
    /// 經緯度座標
    let coordinates: Center
    /// 城市、地址、國家..等資訊
    let location: Location
    let phone, displayPhone: String
    /// 與請求位置之間距離
    let distance: Double
    let price: String?
    let isFavorites: Bool

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, location, phone
        case displayPhone = "display_phone"
        case distance, price
        case isFavorites
    }
}

// MARK: - Category
struct DisplayCategory: Codable {
    let alias, title: String
}

// MARK: - Center
struct DisplayCenter: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct DisplayLocation: Codable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String
    let zipCode: String
    let country: String
    let state: String
    let displayAddress: [String]

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}

enum DisplayAddress3: String, Codable {
    case empty = ""
    case maxwellFoodCenter = "Maxwell Food Center"
    case parkviewSquare = "Parkview Square"
}

// MARK: - Region
struct DisplayRegion: Codable {
    let center: DisplayCenter
}
