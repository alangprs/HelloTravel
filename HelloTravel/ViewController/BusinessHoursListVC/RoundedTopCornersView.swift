//
//  RoundedTopCornersView.swift
//  HelloTravel
//
//  Created by 翁燮羽 on 2023/4/21.
//

import UIKit
import SnapKit

/// 上方圓角 view
class RoundedTopCornersView: UIView {
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(BusinessHoursListCell.self, forCellReuseIdentifier: "\(BusinessHoursListCell.self)")
        tableView.addSubview(headerView)
        return tableView
    }()
    
    // MARK: - headerView 區域
    
    private lazy var headerView: UIView = {
        var view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "營業時間"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    /// 關閉按鈕
    private lazy var closedButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(didClickClosedButton), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - 生命週期
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundTopCorners(radius: 10)
    }

    private func setupUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(closedButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        closedButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-12)
            make.height.width.equalTo(titleLabel.snp.height)
        }
        
    }
    
    /// 上方圓角
    private func roundTopCorners(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    // MARK: - action
    
    @objc private func didClickClosedButton() {
        
    }
}

// MARK: - UITableVIewDelegate

extension RoundedTopCornersView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BusinessHoursListCell.self)", for: indexPath) as? BusinessHoursListCell else {
            return UITableViewCell()
        }
        
        cell.convertCell(title: "星期一", time: "1:00 AM - 10:00 PM")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView
        
    }
    
}
