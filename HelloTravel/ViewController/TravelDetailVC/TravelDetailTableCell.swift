//
//  TravelDetailTableCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/10.
//

import UIKit
import SnapKit

class TravelDetailTableCell: UITableViewCell {

    private lazy var typeNameLabel: UILabel = {
        var label = UILabel()
        label.text = "日本料理"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    /// 營業時間
    private lazy var businessHoursLabel: UILabel = {
        var label = UILabel()
        label.text = "關門中 12:00-14:30, 17:30-21:00"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    /// 全部時間按鈕
    private lazy var allBusinessHoursButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("查看全部時間 →", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        btn.addTarget(self, action: #selector(didClickAllBusinessHoursButton), for: .touchUpInside)
        return btn
    }()

    /// 註冊商店按鈕
    private lazy var registerStoreButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("註冊這商店", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 5
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        btn.addTarget(self, action: #selector(didClickRegisterStoreButton), for: .touchUpInside)
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        contentView.addSubview(typeNameLabel)
        contentView.addSubview(businessHoursLabel)
        contentView.addSubview(allBusinessHoursButton)
        contentView.addSubview(registerStoreButton)

        typeNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(25)
        }

        businessHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(typeNameLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(25)
        }

        allBusinessHoursButton.snp.makeConstraints { make in
            make.top.equalTo(businessHoursLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(25)
        }

        registerStoreButton.snp.makeConstraints { make in
            make.top.equalTo(allBusinessHoursButton.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-6)
        }

    }

    // MARK: - action

    /// 點擊觀看更多按鈕
    @objc private func didClickAllBusinessHoursButton() {
        // TODO: 看更多時間按鈕動作
    }

    @objc private func didClickRegisterStoreButton() {
        // TODO: 註冊商店動作
    }
}
