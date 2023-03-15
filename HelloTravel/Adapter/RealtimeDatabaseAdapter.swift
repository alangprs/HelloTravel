//
//  RealtimeDatabaseAdapter.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/15.
//

import Foundation
import FirebaseDatabase

/// google database
class RealtimeDatabaseAdapter {

    private var database: DatabaseReference?

    /// 即時取得 database 資料
    func referenceData() {
        // TODO: 製作 userInfo 頁面時，思考 database 該如何設計
        database?.database.reference()

        /// 監聽名稱這欄位
        let ref = Database.database().reference(withPath: "name")

        ref.observe(.value) { snapshot in
            if let output = snapshot.value {
                Logger.log(message: output)
            }
        }
    }
}
