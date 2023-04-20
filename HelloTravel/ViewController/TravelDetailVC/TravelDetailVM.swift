//
//  TravelDetailVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/11.
//

import Foundation
import MapKit

protocol TravelDetailVMDelegate: AnyObject {
    // TODO: DisplayBusiness 資料收攏重構
    func getTravelItemSuccess(isLike: Bool)
}

class TravelDetailVM {

    weak var delegate: TravelDetailVMDelegate?
    
    /// 顯示用資料
    private(set) var travelItem: DisplayBusiness?

    /// 資料庫
    private lazy var realtimeDatabaseAdapter: RealtimeDatabaseAdapter = {
        return RealtimeDatabaseAdapter()
    }()

    private var getBusinessByIdUseCase: GetBusinessByIdUseCase?

    private var businessTime: BusinessByIDStruct?
    
    init(travelItem: DisplayBusiness) {
        self.travelItem = travelItem
    }
    
    func getBusinessItem() -> DisplayBusiness? {
        return travelItem
    }

    /// 取得商家詳細資料
    func getBusinessById() {

        guard let id = travelItem?.id else { return }

        getBusinessByIdUseCase = GetBusinessByIdUseCase(id: id)

        getBusinessByIdUseCase?.getBusinessesByID { [weak self] result in

            switch result {

                case .success(let item):
                    self?.businessTime = item
                case .failure(let error):
                    Logger.errorLog(message: error)
            }
        }
    }

    /// 目前是否營業中
//    func isOpenNow() -> Bool {
//        guard let businessTime else { return false }
//
//        return businessTime
//    }

    // MARK: - 地圖相關

    /// 計算路線
    func calculateDistanceAndETA(userLat: Double, userLon: Double, destinationLat: Double, destinationLon: Double, completion: @escaping (_ distance: CLLocationDistance?, _ travelTime: String?, _ error: Error?) -> Void) {
        
        let request = MKDirections.Request()
        let userLocation = CLLocationCoordinate2D(latitude: userLat, longitude: userLon)
        let destination = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLon)
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        // 交通方式
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            
            guard let route = response?.routes.first else {
                completion(nil, nil, error)
                return
            }
            
            // 距離（米）轉 公里
            let distance = route.distance / 1000
            // 時間(秒)
            let travelTime = self.formattedTimeString(time: route.expectedTravelTime)
            
            completion(distance, travelTime, nil)
        }
    }
    
    /// 將秒數轉換成小時、分鐘
    private func formattedTimeString(time: TimeInterval?) -> String? {
        
        guard let time = time else { return ""}
        
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)小時\(minutes)分鐘"
        } else {
            return "\(minutes)分鐘"
        }
        
    }
    
    /// 取得地址
    func assembleAddress() -> String {
        var address = ""
        guard let item = travelItem else { return ""}
        for addressItem in item.location.displayAddress {
            address += addressItem
        }
        
        return address
    }

    /// 判斷是新增 or 取消 收藏
    func toggleLikeStatus() {

        guard let travelItem = travelItem else { return }

        if travelItem.isFavorites {
            Logger.log(message: "取消")
            realtimeDatabaseAdapter.removeLikeListValue(nodeID: travelItem.id)
            delegate?.getTravelItemSuccess(isLike: false)
        } else {
            Logger.log(message: "新增")
            postLikeListData()
        }
    }

    /// 上傳收藏資料
    private func postLikeListData() {

        guard let travelItem = travelItem else { return }

        do {
            let data = try JSONEncoder().encode(travelItem)
            realtimeDatabaseAdapter.postLiktListData(nodeID: travelItem.id, data: data)
            delegate?.getTravelItemSuccess(isLike: true)
        } catch {
            Logger.log(message: "encoder likeList to date error")
        }
    }
    
}

// MARK: - 測試用資料
extension TravelDetailVM {

    /// 模擬打api
    func decodeJson() {
        let jsonStr = jsonString()

        if let data = jsonStr.data(using: .utf8) {
            do {
                let jsonitem = try JSONDecoder().decode(BusinessByIDStruct.self, from: data)
                businessTime = jsonitem
            } catch {
                Logger.errorLog(message: "get decode error")
            }
        }

    }


    private func jsonString() -> String {
        let json =
        """
{
  "id": "wcYmWVGB0kVdjfp3kmovkA",
  "alias": "zhong-guo-la-mian-xiao-long-bao-singapore",
  "name": "Zhong Guo La Mian Xiao Long Bao",
  "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/a5bAZQp1FCY6qseBi0d1tA/o.jpg",
  "is_claimed": false,
  "is_closed": false,
  "url": "https://www.yelp.com/biz/zhong-guo-la-mian-xiao-long-bao-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
  "phone": "",
  "display_phone": "",
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
    ],
    "cross_streets": ""
  },
  "coordinates": {
    "latitude": 1.28218,
    "longitude": 103.84317
  },
  "photos": [
    "https://s3-media3.fl.yelpcdn.com/bphoto/a5bAZQp1FCY6qseBi0d1tA/o.jpg",
    "https://s3-media2.fl.yelpcdn.com/bphoto/IKA3CZbKD2ZWwfjfxLiK8Q/o.jpg",
    "https://s3-media3.fl.yelpcdn.com/bphoto/932DTKl6-jH_XVvUU_zWZA/o.jpg"
  ],
  "price": "$",
  "hours": [
    {
      "open": [
        {
          "is_overnight": false,
          "start": "1130",
          "end": "1500",
          "day": 0
        },
        {
          "is_overnight": false,
          "start": "1700",
          "end": "2030",
          "day": 0
        },
        {
          "is_overnight": false,
          "start": "1130",
          "end": "1500",
          "day": 1
        },
        {
          "is_overnight": false,
          "start": "1700",
          "end": "2030",
          "day": 1
        },
        {
          "is_overnight": false,
          "start": "1130",
          "end": "1500",
          "day": 2
        },
        {
          "is_overnight": false,
          "start": "1700",
          "end": "2030",
          "day": 2
        },
        {
          "is_overnight": false,
          "start": "1130",
          "end": "1500",
          "day": 3
        },
        {
          "is_overnight": false,
          "start": "1700",
          "end": "2030",
          "day": 3
        },
        {
          "is_overnight": false,
          "start": "1130",
          "end": "1500",
          "day": 4
        },
        {
          "is_overnight": false,
          "start": "1700",
          "end": "2030",
          "day": 4
        },
        {
          "is_overnight": false,
          "start": "1130",
          "end": "1500",
          "day": 5
        },
        {
          "is_overnight": false,
          "start": "1700",
          "end": "2030",
          "day": 5
        },
        {
          "is_overnight": false,
          "start": "1130",
          "end": "1500",
          "day": 6
        },
        {
          "is_overnight": false,
          "start": "1700",
          "end": "2030",
          "day": 6
        }
      ],
      "hours_type": "REGULAR",
      "is_open_now": false
    }
  ],
  "transactions": []
}
"""
        return json
    }
}
