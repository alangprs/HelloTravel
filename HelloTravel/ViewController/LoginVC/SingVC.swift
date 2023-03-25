//
//  ViewController.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/14.
//

import UIKit

/// 未登入狀態頁面
class SingVC: UIViewController {

    private lazy var viewModel: SingVM = {
        var vm = SingVM()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.handleAuth()

        // TODO: 註冊可成功
//        viewModel.creatUser(mail: "willwengtest@gmail.com", password: "123456")
        // TODO: 登入可成功
        viewModel.signInWithEMail(mail: "willwengtest@gmail.com", password: "123456")
        // TODO: 登出可成功
//        viewModel.singOut()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.removeAuthHandle()
    }

}

