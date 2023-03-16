//
//  LocationManager.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/16.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    /// 沒有權限
    func noGPSPermission()
    /// 允許過權限
    func haveGPSPermission()
    /// 傳遞座標 緯經度
    func sandLocation(latitude: Double, longitude: Double)
}

class LocationManager: NSObject {

    static let shared = LocationManager()

    weak var delegate: LocationManagerDelegate?

    private var locationManger = CLLocationManager()

    /// 使用者座標
    private var userCoordinate: CLLocationCoordinate2D?
    /// 授權座標狀態
    private var locationAuthorizationStatus: CLAuthorizationStatus = .notDetermined

    private override init() {
        super.init()
        locationManger.delegate = self
        // 設定 gps 移動多少距離更新使用者最新位置資訊
        locationManger.distanceFilter = kCLLocationAccuracyNearestTenMeters
        // 設定 取得自己 gps 定位的精準度
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }

    /// 開啟GPS定位權限
    func askPermission() {

        locationAuthorizationStatus = locationManger.authorizationStatus

        switch locationAuthorizationStatus {
            case .notDetermined:
                // 還沒決定
                locationManger.requestWhenInUseAuthorization()
                locationManger.startUpdatingLocation()
            case .restricted, .denied:
                // 未開啟定位
                delegate?.noGPSPermission()
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                delegate?.haveGPSPermission()
                locationManger.startUpdatingLocation()
            default:
                break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard userCoordinate == nil else {
            Logger.log(message: "userCoordinate is not nil: \(String(describing: userCoordinate))")
            return
        }
        // 取得使用者座標
        userCoordinate = manager.location?.coordinate
        // 更新使用者座標
        manager.stopUpdatingLocation()

        guard let lat = userCoordinate?.latitude,
              let lon = userCoordinate?.longitude else {
            Logger.errorLog(message: "取得使用者座標失敗")
            return
        }
        
        delegate?.sandLocation(latitude: lat, longitude: lon)

    }

    /// 當權限改變時動作
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted, .denied:
                // 沒有權限
                delegate?.noGPSPermission()
            case .authorizedAlways, .authorizedWhenInUse:
                // 允許過權限
                locationManger.startUpdatingLocation()
                delegate?.haveGPSPermission()
            default:
                break
        }
    }
}
