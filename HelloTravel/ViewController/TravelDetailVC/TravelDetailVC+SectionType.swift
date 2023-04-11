//
//  TravelDetailVC+SectionType.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/11.
//

import Foundation

enum TravelDetailSectionType: Int, CaseIterable {
    case topArea = 0
    case placeAction = 1
    case information = 2

    var stringValue: String {
        switch self {
            case .information:
                return "資訊"

            default:
                return ""
        }
    }
}
