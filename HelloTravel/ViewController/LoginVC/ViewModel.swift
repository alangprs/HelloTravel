//
//  ViewModel.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/15.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func creatError()
    func creatSuccess()
}

class ViewModel {

    weak var delegate: ViewModelDelegate?

    private lazy var authenticationAdapter: FirebaseAuthenticationAdapter = {
        return FirebaseAuthenticationAdapter()
    }()

    /// 資料庫
    private lazy var realtimeDatabaseAdapter: RealtimeDatabaseAdapter = {
        return RealtimeDatabaseAdapter()
    }()

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
}
