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

    /// 地點列表
    private lazy var businessSheetVC: BusinessSheetVC = {
        var vc = BusinessSheetVC()
        return vc
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
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.askPermission()
        viewModel.decodeJson()
        
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
        
        presentBusinessSheetVC()
    }
    
    /// 初始高度為最大高度20%
    private func presentBusinessSheetVC() {
        
        if let sheet = businessSheetVC.sheetPresentationController {
            // 關閉滑倒底移除此 view
            businessSheetVC.isModalInPresentation = true
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
            sheet.detents = [.custom(resolver: { context in
                context.maximumDetentValue * 0.3
            }),
                             .medium(),
                             .large()]
        }
        present(businessSheetVC, animated: false)
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

    /// 在地圖上標註地點
    private func showMapPonit() {
        guard !viewModel.pintList.isEmpty else { return }
        
        for pointItem in viewModel.pintList {
            mapView.addAnnotation(pointItem)
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

extension SearchVC: SearchVMDelegate {
    func noGPSPermission() {
        
        locationAlert(title: "未開開啟定位服務", message: "請前往 設定 > 隱私權 > 定位服務，開啟")
    }
    
    func getTravelItemSuccess() {
        // TODO: 取得 api 資料後處理
        showMapPonit()
    }
    
    func getTravelItemError() {
        // TODO: error 處理
    }
    
    func getLocation(latitude: Double, longitude: Double) {
        
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 6000, longitudinalMeters: 6000)
    }

}

