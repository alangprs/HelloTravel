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
    /// true = 登入狀態, false = 未登入
    func handleUseState(completion: @escaping ((Bool) -> Void)) {
        
        authHandle = Auth.auth().addStateDidChangeListener({ auth, user in
            if user != nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }

    /// 移除帳號 登入/登出 狀態監聽
    func removeAuthHandle() {
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
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
