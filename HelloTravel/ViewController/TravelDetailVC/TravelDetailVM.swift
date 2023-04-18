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
    
    init(travelItem: DisplayBusiness) {
        self.travelItem = travelItem
    }
    
    func getBusinessItem() -> DisplayBusiness? {
        return travelItem
    }
    
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
