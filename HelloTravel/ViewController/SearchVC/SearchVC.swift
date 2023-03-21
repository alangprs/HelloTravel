//
//  SearchVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/21.
//

import UIKit
import SnapKit
import MapKit

/// 搜尋頁面
class SearchVC: UIViewController {

    private lazy var viewModel: SearchVM = {
        var vm = SearchVM()
        return vm
    }()

    // MARK: - topView 區域

    private lazy var topView: SearchTopBarView = {
        var view = SearchTopBarView()
        view.delegate = self
        return view
    }()

    private lazy var mapView: MKMapView = {
        var mapView = MKMapView()
        return mapView
    }()

    // MARK: - 生命週期

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }


    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(topView)

        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(6)
        }

        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }

}

// MARK: - SearchTopBarViewDelegate

extension SearchVC: SearchTopBarViewDelegate {
    func goBackViewController() {
        dismiss(animated: true)
    }

    func didTypeSwitch() {
        // TODO: 處理狀態切換
    }

}

