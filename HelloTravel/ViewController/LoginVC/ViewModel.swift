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

}
