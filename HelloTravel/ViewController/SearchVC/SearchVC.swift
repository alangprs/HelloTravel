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

    private var viewModel: SearchVM

    private var topView: SearchTopBarView

    private lazy var mapView: MKMapView = {
        var mapView = MKMapView()
        return mapView
    }()

    // MARK: - 生命週期
    
    init(searchType: CategoryType) {
        self.topView = SearchTopBarView(searchType: searchType)
        self.viewModel = SearchVM(searchType: searchType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(topView)
        topView.delegate = self

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

