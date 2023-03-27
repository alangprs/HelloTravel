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
    func referenceData(completion: @escaping ((Result<[LikeListStructValue], Error>) -> Void)) {
        database?.database.reference()

        // TODO: 取消監聽

        /// 監聽名稱這欄位
        let ref = Database.database().reference(withPath: "likeList")
        var likeList: [LikeListStructValue] = []
        
        ref.observe(.value) { (snapshot, error) in

            if error != nil {
                Logger.errorLog(message: error)
                return
            }

            guard let value = snapshot.value else { return }

            do {
                let data = try JSONSerialization.data(withJSONObject: value)
                let items = try JSONDecoder().decode([String: LikeListStructValue].self, from: data)

                for i in items {
                    likeList.append(i.value)
                }

                completion(.success(likeList))

            } catch(let error) {
                completion(.failure(error))
            }

        }
    }
    
    /// 送出收藏資料到 Firebase Realtime Database
    /// - Parameter data: 要上傳的 data
    func postLiktListData(nodeID: String ,data: Data) {
        let ref = Database.database().reference(withPath: "likeList")

        do {
            // Firebase Realtime Database 只吃 NS 系列，所以轉成 NSDictionary
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            // 將資料上傳 id 為 SearchBusinessesStruct 的 ID
            ref.child(nodeID).setValue(json)

        } catch {
            Logger.log(message: "catch")
        }
        
    }

    /// 移除指定節點ID資料
    /// - Parameter nodeID: 節點位置ID
    func removeLikeListValue(nodeID: String) {
        let ref = Database.database().reference(withPath: ("likeList"))
        
        ref.child(nodeID).removeValue { error,_  in

            if error != nil {
                Logger.errorLog(message: "\(String(describing: error))")
            }
        }
    }

    // TODO: 如果可以直接使用 struct 內的ID 就能刪除資料，這段即可刪除
    /// 取得指定節點ID
    func getNodeID() {
        // 取得 資料節點位置ID
        let ref = Database.database().reference(withPath: ("likeList"))
        ref.observeSingleEvent(of: .value) { snapshot in
            for i in snapshot.children {
                Logger.log(message: "\(i)")
                // TODO: 取得節點ID之後動作
            }

        }
    }

}

// MARK: - 測試用資料

extension RealtimeDatabaseAdapter {
    
    func encodeJson() -> Data? {
        let json = getJsonString1()
        
        return json.data(using: .utf8)
        
    }
    
    private func getJsonString1() -> String {
        let jsonString = """
            {
              "id": "wcYmWVGB0kVdjfp3kmovkA",
              "alias": "zhong-guo-la-mian-xiao-long-bao-singapore",
              "name": "Zhong Guo La Mian Xiao Long Bao",
              "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/a5bAZQp1FCY6qseBi0d1tA/o.jpg",
              "is_closed": false,
              "url": "https://www.yelp.com/biz/zhong-guo-la-mian-xiao-long-bao-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
              "review_count": 34,
              "categories": [
                {
                  "alias": "shanghainese",
                  "title": "Shanghainese"
                },
                {
                  "alias": "dimsum",
                  "title": "Dim Sum"
                },
                {
                  "alias": "noodles",
                  "title": "Noodles"
                }
              ],
              "rating": 4.5,
              "coordinates": {
                "latitude": 1.28218,
                "longitude": 103.84317
              },
              "transactions": [],
              "price": "$",
              "location": {
                "address1": "Blk 335 Smith St",
                "address2": "#02-135",
                "address3": "",
                "city": "Singapore",
                "zip_code": "051335",
                "country": "SG",
                "state": "SG",
                "display_address": [
                  "Blk 335 Smith St",
                  "#02-135",
                  "Singapore 051335",
                  "Singapore"
                ]
              },
              "phone": "",
              "display_phone": "",
              "distance": 274.70245388990696
        }
        """
        
        return jsonString
    }
}
