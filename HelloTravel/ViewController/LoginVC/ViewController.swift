//
//  ViewController.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/14.
//

import UIKit

/// 未登入狀態頁面
class ViewController: UIViewController {

    private lazy var viewModel: ViewModel = {
        var vm = ViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // TODO: 註冊可成功
//        viewModel.creatUser(mail: "willwengtest@gmail.com", password: "123456")
    }
}

