//
//  UserFavoritesVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/27.
//

import Foundation

protocol UserFavoritesVMDelegate: AnyObject {
    func getLikeListSuccess()
}

class UserFavoritesVM {

    weak var delegate: UserFavoritesVMDelegate?

    private(set) var likeList: [LikeListStructValue] = []

    /// 資料庫
    private lazy var realtimeDatabaseAdapter: RealtimeDatabaseAdapter = {
        return RealtimeDatabaseAdapter()
    }()

    /// 即時取得 database 資料
    func referenceData() {
        realtimeDatabaseAdapter.referenceData { [weak self] result in

            guard let self = self else { return }

            switch result {
                case .success(let success):
                    self.likeList = success
                    self.delegate?.getLikeListSuccess()
                case .failure(let failure):
                    Logger.errorLog(message: failure)
            }
        }
    }

    /// 移除資料庫節點資料
    func removeDataValue() {
        // TODO: 節點名稱使用 adapter 內 func 取得
        realtimeDatabaseAdapter.removeLikeListValue(nodeID: "wcYmWVGB0kVdjfp3kmovkA")
    }

    /// 取得 index 物件
    func getLikeItem(index: IndexPath) -> LikeListStructValue? {
        guard !likeList.isEmpty else {
            Logger.errorLog(message: "likeList isEmpty")
            return nil
        }

        return likeList[index.row]
    }

    /// 移除監聽
    func removeAllObservers() {
        realtimeDatabaseAdapter.removeAllObservers()
    }

    // TODO: 暫時測試使用，先放在這
    /// 上傳收集清單資料
    func postData() {
        guard let data = realtimeDatabaseAdapter.encodeJson() else { return }
        // TODO: 取得點擊到的 Business 結構的 ID
        realtimeDatabaseAdapter.postLiktListData(nodeID: "wcYmWVGB0kVdjfp3kmovkA", data: data)
    }

}
