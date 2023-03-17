//
//  NearbyLandmarkVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/17.
//

import UIKit
import SnapKit

/// 依照座標顯顯示周圍景點
class NearbyLandmarkVC: UIViewController {

    private lazy var viewModel: NearbyLandmarkVM = {
        var vm = NearbyLandmarkVM()
        vm.delegate = self
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.askPermission()
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

// MARK: -

extension NearbyLandmarkVC: NearbyLandmarkVMDelegate {
    func noGPSPermission() {
        locationAlert(title: "未開開啟定位服務", message: "請前往 設定 > 隱私權 > 定位服務，開啟")
    }
}
