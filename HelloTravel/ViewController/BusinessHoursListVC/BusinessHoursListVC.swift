//
//  BusinessHoursListVC.swift
//  HelloTravel
//
//  Created by 翁燮羽 on 2023/4/21.
//

import UIKit
import SnapKit

class BusinessHoursListVC: UIViewController {
    
    private lazy var contenerView: RoundedTopCornersView = {
        var view = RoundedTopCornersView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(contenerView)
        
        contenerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
}
