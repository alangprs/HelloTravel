//
//  RoundedTopCornersViewVM.swift
//  HelloTravel
//
//  Created by 翁燮羽 on 2023/4/21.
//

import Foundation

class RoundedTopCornersViewVM {
    
    private(set) lazy var weekdayCount: Int = {
        return Weekday.allCases.count
    }()
    
    /// 由於enum順序由1開始，所以index +1
    func getWeekday(index: IndexPath) -> String {
        guard let weekday = Weekday(rawValue: index.row + 1)?.weekDayString else {
            print("w - not")
            return ""}
        return weekday
    }
    
}

// MARK: - 星期顯示

extension RoundedTopCornersViewVM {
    enum Weekday: Int, CaseIterable {
        /// 星期日
        case sunDay = 1
        /// 星期一
        case monDay = 2
        /// 星期二
        case tuesDay = 3
        /// 星期三
        case wednesDay = 4
        /// 星期四
        case thursDay = 5
        /// 星期五
        case friDay = 6
        /// 星期六
        case saturDay = 7

        var weekDayString: String {
            switch self {
                case .sunDay:
                    return "星期日"
                case .monDay:
                    return "星期一"
                case .tuesDay:
                    return "星期二"
                case .wednesDay:
                    return "星期三"
                case .thursDay:
                    return "星期四"
                case .friDay:
                    return "星期五"
                case .saturDay:
                    return "星期六"
            }
        }
    }
}
