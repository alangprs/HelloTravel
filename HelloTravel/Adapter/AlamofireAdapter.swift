//
//  AlamofireAdapter.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/15.
//

import Foundation
import Alamofire

class AlamofireAdapter {

    // MARK: Private
    private lazy var session: Session = .init()

    /// - Parameters:
    ///   - url: api網址
    ///   - parameters: 參數
    ///   - httpHeader: httpHeader
    ///   - completion: 傳遞完成後動作
    func getNetwork(url: String, parameters: Parameters? = nil, httpHeader: HTTPHeaders? = nil, completion: @escaping ((Data?, HTTPURLResponse?, Error?) -> Void)) {
        session.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: httpHeader)
            .response { afResponse in

                completion(afResponse.data, afResponse.response, afResponse.error)
            }
    }

    /// - Parameters:
    ///   - url: api 網址
    ///   - parameters: 參數
    ///   - httpHeader: httpHeader
    ///   - completion: 傳遞完成後動作
    func postNetwork(url: String, parameters: Parameters? = nil, httpHeader: HTTPHeaders? = nil, completion: @escaping ((Data?, HTTPURLResponse?, Error?) -> Void)) {
        session.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: httpHeader).response { afResponse in

            completion(afResponse.data, afResponse.response, afResponse.error)
        }
    }
}
