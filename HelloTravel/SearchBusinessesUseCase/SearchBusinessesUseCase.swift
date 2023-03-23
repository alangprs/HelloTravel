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
    
    private var components: URLComponents

    private lazy var scheme = "https"
    private lazy var host = "api.yelp.com"
    private lazy var path = "/v3/businesses/search"
    /// 搜尋範圍
    private var radius = "3000"
    /// 結果數量
    private var limit = 20
    private var sortType = "best_match"


    /// 依種類名稱 + 經緯度搜尋
    init(term: String, latitude: Double, longitude: Double) {

        self.components = URLComponents()
        self.components.scheme = scheme
        self.components.host = host
        self.components.path = path
        self.components.queryItems = [
            URLQueryItem(name: "term", value: "\(term)"),
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)"),
            URLQueryItem(name: "radius", value: radius),
            URLQueryItem(name: "sort_by", value: sortType),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
    }

    /// 依緯經度搜尋
    init(latitude: Double, longitude: Double) {
        self.components = URLComponents()
        self.components.scheme = scheme
        self.components.host = host
        self.components.path = path
        self.components.queryItems = [
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)"),
            URLQueryItem(name: "radius", value: radius),
            URLQueryItem(name: "sort_by", value: sortType),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
    }

    /// 取周圍資料
    func getBusinessesData(completion: @escaping ((Result<SearchBusinessesStruct, Error>) -> Void)) {

        // 看文件
        let apiKey = "rtVfPX3G9utzCM1mQEX0vk94aVpUZMm0GZt6Xq6Y-dLBKubWIkFW0cqV9F1O8bzZBQmScmfWWWGUZjzyaTWUYzTLBFnMe1bDz9afhpCdO8zh1BX_rHMIh8uDfvQOZHYx"
        
        guard let url = components.url else {
            Logger.errorLog(message: "get url error")
            return
        }
        
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
