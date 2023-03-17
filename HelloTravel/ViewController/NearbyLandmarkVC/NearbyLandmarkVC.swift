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

    // MARK: - 最上方區域
    private lazy var topView: UIView = {
        var view = UIView()

        return view
    }()

    private lazy var bgImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "KabdnarkTop")
        return imageView
    }()

    private lazy var topTitleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "你周圍的餐廳、景點"
        return label
    }()

    // MARK: -

    // MARK: - 生命週期

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        viewModel.askPermission()
    }

    // MARK: - 其他

    private func setupUI() {
        setupTopView()
    }

    private func setupTopView() {
        view.addSubview(topView)
        topView.backgroundColor = .systemRed
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(280)
        }

        topView.addSubview(bgImage)
        bgImage.backgroundColor = .systemGray

        topView.addSubview(topTitleLabel)

        bgImage.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        topTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(12)
        }
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

// MARK: - NearbyLandmarkVMDelegate

extension NearbyLandmarkVC: NearbyLandmarkVMDelegate {
    func noGPSPermission() {
        locationAlert(title: "未開開啟定位服務", message: "請前往 設定 > 隱私權 > 定位服務，開啟")
    }
}
