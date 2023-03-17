//
//  SearchBusinessesUseCase.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/15.
//

import Foundation

/// 搜尋地點相關 useCase
class SearchBusinessesUseCase {

    private lazy var alamofireAdapoter: AlamofireAdapter = {
        return AlamofireAdapter()
    }()

    private var businesses: String
    private var search: String
    private var location: String?
    /// 搜尋範圍
    private var radius: String
    /// 結果數量
    private var limit: Int
    private var sortType: String
    /// 緯度
    private var latitude: Double?
    /// 經度
    private var longitude: Double?
    private var query: String

    /// 依名稱搜尋
    init(location: String) {
        self.businesses = "/businesses"
        self.search = "search"
        self.location = location
        self.radius = "3000"
        self.limit = 20
        self.sortType = "best_match"
        self.query = "?location=\(location)&radius=\(radius)&sort_by=\(sortType)&limit=\(limit)"
    }

    /// 依緯經度搜尋
    init(latitude: Double, longitude: Double) {
        self.businesses = "/businesses"
        self.search = "/search"
        self.radius = "3000"
        self.limit = 20
        self.sortType = "best_match"
        self.latitude = latitude
        self.longitude = longitude
        self.query = "?latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)&sort_by=\(sortType)&limit=\(limit)"
    }

    /// 取周圍資料
    func getBusinessesData(completion: @escaping ((Result<SearchBusinessesStruct, Error>) -> Void)) {

        let Host: String = "https://api.yelp.com/v3"

        // 看文件

        let url = Host + businesses + search + query
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer " + apiKey
        ]

        alamofireAdapoter.getNetwork(url: url, httpHeader: .init(headers)) { data, _, error in

            if let data = data {
                do {
                    let assetLendingList = try JSONDecoder().decode(SearchBusinessesStruct.self, from: data)
                    completion(.success(assetLendingList))
                } catch {
                    completion(.failure(error))
                }
            } else {
                Logger.errorLog(message: "api error")
            }
        }
    }
}
