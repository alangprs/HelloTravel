//
//  TravelDetailVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/11.
//

import Foundation
import MapKit

class TravelDetailVM {

    /// 顯示用資料
    private(set) var travelItem: DisplayBusiness?

    init(travelItem: DisplayBusiness) {
        self.travelItem = travelItem
    }

    func getBusinessItem() -> DisplayBusiness? {
        return travelItem
    }

    /// 計算路線
    func calculateDistanceAndETA(userLat: Double, userLon: Double, destinationLat: Double, destinationLon: Double, completion: @escaping (_ distance: CLLocationDistance?, _ travelTime: TimeInterval?, _ error: Error?) -> Void) {

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

            // 距離（米）
            let distance = route.distance
            // 時間(秒)
            let travelTime = route.expectedTravelTime

            completion(distance, travelTime, nil)
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

}
