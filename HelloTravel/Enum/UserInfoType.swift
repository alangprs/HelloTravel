//
//  UserInfoType.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/17.
//

import Foundation

enum UserInfoType: CaseIterable {
    /// 動態
    case dynamic
    /// 收藏
    case favorites
    /// 刪除帳號
    case deleteAccount
    /// 登出
    case SignOut

    var typeTitle: String {
        switch self {
            case .dynamic:
                return "動態"
            case .favorites:
                return "收藏"
            case .deleteAccount:
                return "刪除帳號"
            case .SignOut:
                return "登出"
        }
    }
}
