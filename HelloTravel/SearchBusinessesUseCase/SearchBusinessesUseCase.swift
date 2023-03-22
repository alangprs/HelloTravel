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

    private lazy var businesses = "/businesses"
    private lazy var search = "/search"
    /// 搜尋範圍
    private var radius = "3000"
    /// 結果數量
    private var limit = 20
    private var sortType = "best_match"
    private var query: String

    /// 依種類名稱 + 經緯度搜尋
    init(term: String, latitude: Double, longitude: Double) {
        self.query = "?latitude=\(latitude)&longitude=\(longitude)&term=\(term)&radius=\(radius)&sort_by=\(sortType)&limit=\(limit)"
    }

    /// 依緯經度搜尋
    init(latitude: Double, longitude: Double) {
        self.query = "?latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)&sort_by=\(sortType)&limit=\(limit)"
    }

    /// 取周圍資料
    func getBusinessesData(completion: @escaping ((Result<SearchBusinessesStruct, Error>) -> Void)) {

        let Host: String = "https://api.yelp.com/v3"

        // 看文件
        let apiKey = "rtVfPX3G9utzCM1mQEX0vk94aVpUZMm0GZt6Xq6Y-dLBKubWIkFW0cqV9F1O8bzZBQmScmfWWWGUZjzyaTWUYzTLBFnMe1bDz9afhpCdO8zh1BX_rHMIh8uDfvQOZHYx"

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
