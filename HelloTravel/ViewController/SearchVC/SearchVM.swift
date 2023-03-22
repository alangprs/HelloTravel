//
//  SearchVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/21.
//

import Foundation
import MapKit

protocol SearchVMDelegate: AnyObject {
    func noGPSPermission()
    func getTravelItemSuccess()
    func getTravelItemError()
    /// 傳遞座標
    func getLocation(latitude: Double, longitude: Double)
}

class SearchVM {
    
    // MARK: - 參數
    
    weak var delegate: SearchVMDelegate?
    
    private(set) lazy var locationItemList: [Business] = {
        return [Business]()
    }()
    
    private var searchType: CategoryType
    
    private lazy var locationManager: LocationManager = {
        var locationManager = LocationManager.shared
        locationManager.delegate = self
        return locationManager
    }()
    
    private(set) var travelList: [Business] = []
    /// 地圖標記
    private(set) var pintList: [MKPointAnnotation] = []
    
    /// 取附近資料
    private var searchBusinessesUseCase: SearchBusinessesUseCase?
    
    init(searchType: CategoryType) {
        self.searchType = searchType
    }
    
    /// 詢問定位權限
    func askPermission() {
        locationManager.askPermission()
    }
        
    /// 依當前坐標位置，使用狀態搜尋
    private func searchLocation() {
        
        searchBusinessesUseCase?.getBusinessesData(completion: { result in
            switch result {
            case .success(let item):
                Logger.log(message: item.businesses)
                self.travelList = item.businesses
                self.delegate?.getTravelItemSuccess()
            case .failure(let error):
                Logger.errorLog(message: error)
                self.delegate?.getTravelItemError()
            }
        })
        
    }
    
    /// 產出地點標記
    private func createMapPoint() {
        
        guard !travelList.isEmpty else { return }
        for index in 1 ..< travelList.count {
            
            let point = MKPointAnnotation()
            
            let latitude = travelList[index].coordinates.latitude
            let longitude = travelList[index].coordinates.longitude
            
            point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            point.title = "\(index)"
            
            pintList.append(point)
        }
    }
    
}

// MARK: - 定位

extension SearchVM: LocationManagerDelegate {
    func sandLocation(latitude: Double, longitude: Double) {
        
        // TODO: - 先寫死在新加坡，不然台灣東西太少
        searchBusinessesUseCase = SearchBusinessesUseCase(term: "restaurant", latitude: 1.284066, longitude: 103.841114)
        delegate?.getLocation(latitude: 1.284066, longitude: 103.841114)
//        searchLocation()
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

