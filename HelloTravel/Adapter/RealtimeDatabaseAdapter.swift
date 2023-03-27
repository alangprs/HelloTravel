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
        database?.database.reference()
        
        /// 監聽名稱這欄位
        let ref = Database.database().reference(withPath: "likeList")
        
        ref.observe(.value) { snapshot in
            if let output = snapshot.value {
                Logger.log(message: output)
            }
        }
    }
    
    /// 送出收藏資料到 Firebase Realtime Database
    /// - Parameter data: 要上傳的 data
    func postLiktListData(data: Data) {
        let ref = Database.database().reference(withPath: "likeList")

        do {
            // Firebase Realtime Database 只吃 NS 系列，所以轉成 NSDictionary
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            // 將資料上傳到
            ref.childByAutoId().setValue(json)

        } catch {
            Logger.log(message: "catch")
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
