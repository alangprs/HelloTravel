//
//  NearbyLandmarkVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/17.
//

import Foundation

protocol NearbyLandmarkVMDelegate: AnyObject {
    func noGPSPermission()
}

class NearbyLandmarkVM {

    weak var delegate: NearbyLandmarkVMDelegate?

    private lazy var locationManager: LocationManager = {
        var locationManager = LocationManager.shared
        locationManager.delegate = self
        return locationManager
    }()

    /// 取附近資料
    private var searchBusinessesUseCase: SearchBusinessesUseCase?
    
    /// 詢問定位權限
    func askPermission() {
        locationManager.askPermission()
    }

    /// 取得周圍景點
    /// - Parameters:
    ///   - latitude: 緯度
    ///   - longitude: 經度
    private func getNearbyAttractions() {

        searchBusinessesUseCase?.getBusinessesData { result in

            // TODO: 取得周圍景點後動作
            switch result {
                case .success(let item):
                    Logger.log(message: item.businesses)
                case .failure(let error):
                    Logger.errorLog(message: error)
            }
        }
    }
}

// MARK: - 定位

extension NearbyLandmarkVM: LocationManagerDelegate {
    func sandLocation(latitude: Double, longitude: Double) {

        searchBusinessesUseCase = SearchBusinessesUseCase(latitude: latitude, longitude: longitude)
        getNearbyAttractions()
    }

    func noGPSPermission() {
        delegate?.noGPSPermission()
        Logger.log(message: "clickDenied")
    }

    func haveGPSPermission() {
        // TODO: 有給過權限相關動作
        Logger.log(message: "wheninuse")
    }
}
