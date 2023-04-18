//
//  UserInfoVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/18.
//

import Foundation

class UserInfoVM {

    private lazy var authenticationAdapter: FirebaseAuthenticationAdapter = {
        return FirebaseAuthenticationAdapter()
    }()

    /// 登出
    func singOut(completion: @escaping ((Result<Void, Error>) -> Void)) {
        authenticationAdapter.singOut { result in

            switch result {
                case .success(_):
                    UserDefaultsManager.shared.removeUserID()
                    Logger.log(message: "登出成功")
                    completion(.success(Void()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
