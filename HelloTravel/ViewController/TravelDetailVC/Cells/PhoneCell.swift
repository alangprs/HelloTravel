//
//  PhoneCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/11.
//

import UIKit
import SnapKit

/// 電話功能
class PhoneCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "撥打電話"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var phoneNumberLabel: UILabel = {
        var label = UILabel()
        label.text = "0919306789"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    /// 撥打電話圖標
    private lazy var phoneImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone.arrow.up.right")
        return imageView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(phoneImageView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
        }

        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(20)
        }

        phoneImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
}
