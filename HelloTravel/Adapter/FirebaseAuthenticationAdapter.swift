//
//  FirebaseAuthenticationAdapter.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/15.
//

import Foundation
import FirebaseAuth

class FirebaseAuthenticationAdapter {

    // 帳號狀態，登出時清除
    private var authHandle: AuthStateDidChangeListenerHandle?

    /// 監控使用者登入狀態
    func handleUseState() {
        // TODO: 監控使用者登入狀態
        authHandle = Auth.auth().addStateDidChangeListener({ auth, user in
            Logger.log(message: "auth: \(auth), user: \(String(describing: user))")
        })
    }

    /// 創新使用者
    func createUser(mail: String, password: String, completion: @escaping ((Result<AuthDataResult,Error>) -> Void)) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in

            if let error = error {
                completion(.failure(error))
            }

            if let result = authResult {
                completion(.success(result))
            }
        }
    }

}
