//
//  NearbyLandmarkVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/17.
//

import UIKit

protocol NearbyLandmarkVMDelegate: AnyObject {
    func noGPSPermission()
    func getTravelItemSuccess()
    func getTravelItemError()
}

class NearbyLandmarkVM {

    weak var delegate: NearbyLandmarkVMDelegate?

    private lazy var locationManager: LocationManager = {
        var locationManager = LocationManager.shared
        locationManager.delegate = self
        return locationManager
    }()

    private(set) var travelList: [Business] = []

    /// 取附近資料
    private var searchBusinessesUseCase: SearchBusinessesUseCase?
    
    /// 詢問定位權限
    func askPermission() {
        locationManager.askPermission()
    }

    func getTravelItem(indexPath: IndexPath) -> Business? {
        guard !travelList.isEmpty else {
            Logger.errorLog(message: "\(travelList)")
            return nil
        }
        return travelList[indexPath.item]
    }

    /// 計算要顯示的星星圖片
    /// - Parameter starsCount: 星星數量
    /// - Returns: 星星圖片
    func calculateStarIcon(starsCount: Double) -> UIImage {
        var image = UIImage()
        switch starsCount {

            case 1:
                Logger.log(message: "星星 1")
                image = UIImage(named: "star1") ?? UIImage()
            case 2:
                Logger.log(message: "星星 2")
            case 3:
                Logger.log(message: "星星 3")
            case 4:
                Logger.log(message: "星星 4")
            case 5:
                Logger.log(message: "星星 5")

            default:
                Logger.errorLog(message: "未取得星星數量")
                return image
        }

        return image
    }

    /// 取得周圍景點
    /// - Parameters:
    ///   - latitude: 緯度
    ///   - longitude: 經度
    private func getNearbyAttractions() {

        searchBusinessesUseCase?.getBusinessesData { [weak self] result in
            guard let self = self else { return }

            // TODO: 取得周圍景點後動作
            switch result {
                case .success(let item):
                    Logger.log(message: item.businesses)
                    self.travelList = item.businesses
                    self.delegate?.getTravelItemSuccess()
                case .failure(let error):
                    Logger.errorLog(message: error)
                    self.delegate?.getTravelItemError()
            }
        }
    }
}

// MARK: - 定位

extension NearbyLandmarkVM: LocationManagerDelegate {
    func sandLocation(latitude: Double, longitude: Double) {

        // TODO: - 先寫死在新加坡，不然台灣東西太少
        searchBusinessesUseCase = SearchBusinessesUseCase(latitude: 1.284066, longitude: 103.841114)
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
