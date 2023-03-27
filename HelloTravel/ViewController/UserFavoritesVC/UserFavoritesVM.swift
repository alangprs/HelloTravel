//
//  UserFavoritesVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/27.
//

import Foundation

class UserFavoritesVM {

    /// 資料庫
    private lazy var realtimeDatabaseAdapter: RealtimeDatabaseAdapter = {
        return RealtimeDatabaseAdapter()
    }()

    /// 即時取得 database 資料
    func referenceData() {
        realtimeDatabaseAdapter.referenceData()
    }

}
