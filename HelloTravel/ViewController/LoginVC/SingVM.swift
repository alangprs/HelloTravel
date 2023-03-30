//
//  ViewModel.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/15.
//

import Foundation

protocol SingVMDelegate: AnyObject {
    /// 沒有權限
    func noGPSPermission()
}

class SingVM {

    weak var delegate: SingVMDelegate?

    private lazy var authenticationAdapter: FirebaseAuthenticationAdapter = {
        return FirebaseAuthenticationAdapter()
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
                    let userID = success.user.uid
                    UserDefaultsManager.shared.setUserID(userID: userID)
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
                    UserDefaultsManager.shared.removeUserID()
                    Logger.log(message: "登出成功")
                case .failure(let error):
                    Logger.errorLog(message: error)
            }
        }
    }

}
