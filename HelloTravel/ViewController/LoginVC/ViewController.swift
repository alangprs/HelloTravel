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
        vm.delegate = self
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
//        viewModel.signInWithEMail(mail: "willwengtest@gmail.com", password: "123456")
        // TODO: 登出可成功
//        viewModel.singOut()
        // TODO: 取座標、打api撈周圍景點資料可成功
//        viewModel.askPermission()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.removeAuthHandle()
    }

    /// 未開啟定位通知
    private func locationAlert(title: String, message: String) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }

        alertControl.addAction(okAction)
        present(alertControl, animated: true)
    }
}

// MARK: - ViewModelDelegate

extension ViewController: ViewModelDelegate {
    func noGPSPermission() {
        locationAlert(title: "未開開啟定位服務", message: "請前往 設定 > 隱私權 > 定位服務，開啟")
    }
}
