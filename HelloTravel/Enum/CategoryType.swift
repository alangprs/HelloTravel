//
//  CategoryType.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/21.
//

import Foundation

/// 景點種類分類
enum CategoryType {
    case restaurant
    case massage
    case travel

    var typeTitle: String {
        switch self {
            case .restaurant:
                return "餐廳"
            case .massage:
                return "按摩"
            case .travel:
                return "旅遊"
        }
    }
}
