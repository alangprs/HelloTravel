//
//  TravelDetailVC+SectionType.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/11.
//

import Foundation

/// 表示 tableView 的不同 section 類型。
enum TravelDetailSectionType: Int, CaseIterable {
    /// 顯示頂部區域，例如圖片或其他視覺元素。
    case topArea

    /// 顯示地點相關操作，例如添加評論、分享、收藏等。
    case placeAction

    /// 顯示地點的詳細信息，例如營業時間、電話等。
    case information

    var stringValue: String {
        switch self {
            case .information:
                return "資訊"

            default:
                return ""
        }
    }
}

/// 表示 information section 中的不同 cell 類型。
enum InformationCellType: Int {
    /// 顯示地點的營業時間。
    case businessHours = 0

    /// 顯示地點的聯繫電話。
    case phone = 1

    /// 顯示地圖導航資訊
    case map = 2
}
