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

    /// 使用 mail 登入
    func signInWithEMail(mail: String, password: String, completion: @escaping ((Result<AuthDataResult,Error>) -> Void)) {
        Auth.auth().signIn(withEmail: mail, password: password) { result, error in

            if let error = error {
                completion(.failure(error))
            }

            if let result = result {
                completion(.success(result))
            }
        }
    }

    /// 登出
    func singOut(completion: @escaping ((Result<Void,Error>) -> Void)) {

        do {
            try Auth.auth().signOut()
            completion(.success(Void()))
        } catch let error {
            completion(.failure(error))
        }
    }

}
