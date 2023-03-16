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

    /// 取周圍資料
    func getBusinessesData(completion: @escaping ((Result<SearchBusinessesStruct, Error>) -> Void)) {

        let Host: String = "https://api.yelp.com/v3"
        let businesses: String = "/businesses"
        let search: String = "/search"
        let query: String = "?location=Singapore&radius=20000&sort_by=best_match&limit=20"

        // 看文件
        let apiKey: String = ""

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
