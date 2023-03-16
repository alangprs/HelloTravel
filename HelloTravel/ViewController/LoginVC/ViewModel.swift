//
//  ViewModel.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/15.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    /// 沒有權限
    func noGPSPermission()
}

class ViewModel {

    weak var delegate: ViewModelDelegate?

    private lazy var authenticationAdapter: FirebaseAuthenticationAdapter = {
        return FirebaseAuthenticationAdapter()
    }()

    private lazy var locationManager: LocationManager = {
        var locationManager = LocationManager.shared
        locationManager.delegate = self
        return locationManager
    }()

    /// 取附近資料
    private var searchBusinessesUseCase: SearchBusinessesUseCase?

    /// 資料庫
    private lazy var realtimeDatabaseAdapter: RealtimeDatabaseAdapter = {
        return RealtimeDatabaseAdapter()
    }()

    // MARK: - 登入相關

    func handleAuth() {
        authenticationAdapter.handleUseState { isLogin in

            if isLogin {
                Logger.log(message: "登入狀態")
            } else {
                Logger.log(message: "未登入")
            }
        }
    }

    func removeAuthHandle() {
        authenticationAdapter.removeAuthHandle()
    }

    /// 創建帳號
    func creatUser(mail: String, password: String) {
        authenticationAdapter.createUser(mail: mail,
                                         password: password) { result in
            switch result {
                case .success(let success):
                    Logger.log(message: success)
                case .failure(let failure):
                    Logger.errorLog(message: failure)
            }
        }
    }

    /// 登入
    func signInWithEMail(mail: String, password: String) {
        authenticationAdapter.signInWithEMail(mail: mail, password: password) { result in

            switch result {
                case .success(let success):
                    Logger.log(message: success)
                case .failure(let failure):
                    Logger.errorLog(message: failure)
            }
        }
    }

    /// 登出
    func singOut() {
        authenticationAdapter.singOut { result in

            switch result {
                case .success(_):
                    Logger.log(message: "登出成功")
                case .failure(let error):
                    Logger.errorLog(message: error)
            }
        }
    }

    // MARK: - Database

    /// 即時取得 database 資料
    func referenceData() {
        realtimeDatabaseAdapter.referenceData()
    }

    // MARK: - 其他

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

    /// 詢問定位權限
    func askPermission() {
        locationManager.askPermission()
    }
}

// MARK: - 定位

extension ViewModel: LocationManagerDelegate {
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
