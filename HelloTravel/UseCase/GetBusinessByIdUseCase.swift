//
//  GetBusinessByIdUseCase.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/20.
//

import Foundation

/// 依照地點ID取得更多相關資訊(照片、營業時間...)
class GetBusinessByIdUseCase {
    private lazy var alamofireAdapoter: AlamofireAdapter = {
        return AlamofireAdapter()
    }()

    private var components: URLComponents

    private lazy var scheme = "https"
    private lazy var host = "api.yelp.com"
    private lazy var path = "/v3/businesses/"

    init(id: String) {
        self.components = URLComponents()
        self.components.scheme = scheme
        self.components.host = host
        self.components.path = path + id
    }

    /// 依照ID 取得地點相關資料
    func getBusinessesByID(completion: @escaping ((Result<BusinessByIDStruct, Error>) -> Void)) {

        // api key 看文件
        let apiKey = ""

        guard let url = components.url else {
            Logger.errorLog(message: "get url error")
            return
        }

        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer " + apiKey
        ]

        alamofireAdapoter.getNetwork(url: url, httpHeader: .init(headers)) { data, responst, error in

            if let data = data {
                do {
                    let assetLendingList = try JSONDecoder().decode(BusinessByIDStruct.self, from: data)
                    completion(.success(assetLendingList))
                } catch {
                    completion(.failure(error))
                }
            } else {
                Logger.errorLog(message: "api error: \(String(describing: error))")
            }
        }
    }
}
