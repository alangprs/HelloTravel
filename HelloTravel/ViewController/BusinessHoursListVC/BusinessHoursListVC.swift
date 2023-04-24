//
//  BusinessHoursListVC.swift
//  HelloTravel
//
//  Created by 翁燮羽 on 2023/4/21.
//

import UIKit
import SnapKit

/// 裝顯示營業時間View的容器
class BusinessHoursListVC: UIViewController {
    
    private lazy var contenerView: RoundedTopCornersView = {
        var view = RoundedTopCornersView()
        view.delegate = self
        view.backgroundColor = .white
        return view
    }()

    init(data: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.contenerView.viewModel.updateBusinessHoursData(data: data)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addTapGestureToView()
    }
    
    private func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.addSubview(contenerView)
        
        contenerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }

    /// 為view 加入點擊事件
    private func addTapGestureToView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
    }

    private func dismissView() {
        dismiss(animated: true)
    }

    // MARK: - anction

    @objc func viewTapped() {
        dismissView()
    }
}

// MARK: - RoundedTopCornersView Delegate

extension BusinessHoursListVC: RoundedTopCornersViewDelegate {
    func didDismiss() {
        dismissView()
    }
}
