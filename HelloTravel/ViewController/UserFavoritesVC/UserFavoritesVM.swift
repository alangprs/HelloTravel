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
        if likeList.indices.contains(index.row) {
            return likeList[index.row]
        } else {
            Logger.errorLog(message: "likeItem is out range")
            return nil
        }
        
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

    /// 根據給定的 IndexPath，將 likeList 中的對象映射到 DisplayBusiness 類型，方便顯示
    /// - Parameter indexPath: 要查找的對象的 IndexPath
    /// - Returns: 如果對象存在，則返回對應的 DisplayBusiness，否則返回 nil
    func mapTravelListToDisplayBusiness(indexPath: IndexPath) -> DisplayBusiness? {
        guard likeList.indices.contains(indexPath.row) else {
            return nil
        }

        let selectItem = likeList[indexPath.row]
        let isFavorite = getIsFavorite(id: selectItem.id)
        let category: [Category] = mapLikeListCategoriesToDisplayCategories(indexCategories: selectItem.categories)
        let coordinates: Center = mapCoordinatesToCenter(coordinates: selectItem.coordinates)
        let location: Location = mapLikeListLocationToDisplayLocation(location: selectItem.location)

        var likeData: DisplayBusiness = .init(id: selectItem.id,
                                              alias: selectItem.alias,
                                              name: selectItem.name,
                                              imageURL: selectItem.imageURL,
                                              isClosed: selectItem.isClosed,
                                              url: selectItem.url,
                                              reviewCount: selectItem.reviewCount,
                                              categories: category,
                                              rating: selectItem.rating,
                                              coordinates: coordinates,
                                              location: location,
                                              phone: selectItem.phone,
                                              displayPhone: selectItem.displayPhone,
                                              distance: selectItem.distance,
                                              price: selectItem.price,
                                              isFavorites: isFavorite)

        return likeData
    }

    /// 將 LikeListCategory 對象轉換為 Category 對象，以便顯示
    /// - Parameter indexCategories: 要轉換的 LikeListCategory 對象數組
    /// - Returns: 轉換後的 Category 對象數組
    private func mapLikeListCategoriesToDisplayCategories(indexCategories: [LikeListCategory]) -> [Category] {
        var category: [Category] = []
        for indexItem in indexCategories {
            let newItem: Category = .init(alias: indexItem.alias, title: indexItem.title)
            category.append(newItem)
        }

        return category
    }

    /// 將 Coordinates 對象轉換為 Center 對象
    /// - Parameter coordinates: 要轉換的 Coordinates 對象
    /// - Returns: 轉換後的 Center 對象
    private func mapCoordinatesToCenter(coordinates: Coordinates) -> Center {
        return Center.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }

    /// 將 LikeListLocation 對象轉換為 Location 對象
    /// - Parameter location: 要轉換的 LikeListLocation 對象
    /// - Returns: 轉換後的 Location 對象
    private func mapLikeListLocationToDisplayLocation(location: LikeListLocation) -> Location {
        return Location.init(address1: location.address1,
                             address2: location.address2,
                             address3: location.address3,
                             city: location.city ?? "",
                             zipCode: location.zipCode,
                             country: location.country,
                             state: location.state,
                             displayAddress: location.displayAddress)
    }

    /// 檢查給定的 id 是否存在於收藏清單中
    /// - Parameter id: 要檢查的對象的 id
    /// - Returns: 如果存在於收藏清單中，則返回 true，否則返回 false
    private func getIsFavorite(id: String) -> Bool {
        guard !likeList.isEmpty else { return false }

        for like in likeList {
            if like.id == id {
                return true
            }
        }
        return false
    }

}
