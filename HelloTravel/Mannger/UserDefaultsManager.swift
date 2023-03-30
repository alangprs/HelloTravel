//
//  UserDefaultsManager.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/30.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    enum Keys: String {
        case userID = "userID"
    }

    /// 存使用者UID
    /// - Parameter userID: 使用者 UID
    func setUserID(userID: String) {
        UserDefaults.standard.setValue(userID, forKey: Keys.userID.rawValue)
    }

    /// 取得使用者 UID
    /// - Returns: 使用者UID
    func getUserID() -> String? {
        return UserDefaults.standard.string(forKey: Keys.userID.rawValue)
    }


    /// 移除使用者 UID
    func removeUserID() {
        UserDefaults.standard.removeObject(forKey: Keys.userID.rawValue)
    }
}
