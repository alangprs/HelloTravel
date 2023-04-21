//
//  BusinessHoursListCell.swift
//  HelloTravel
//
//  Created by 翁燮羽 on 2023/4/21.
//

import UIKit
import SnapKit

class BusinessHoursListCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 控制Cell
    /// - Parameters:
    ///   - title: 星期
    ///   - time: 營業時間
    func convertCell(title: String, time: String) {
        titleLabel.text = title
        timeLabel.text = time
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().offset(12)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
}
