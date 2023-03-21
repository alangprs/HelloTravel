//
//  SearchVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/21.
//

import UIKit
import SnapKit

/// 搜尋頁面
class SearchVC: UIViewController {

    private lazy var viewModel: SearchVM = {
        var vm = SearchVM()
        return vm
    }()

    // MARK: - topView 區域

    private lazy var topView: SearchTopBarView = {
        /// TODO: 接事件
        return SearchTopBarView()
    }()

    // MARK: - 生命週期

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.addSubview(topView)

        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(6)
        }
    }

}


