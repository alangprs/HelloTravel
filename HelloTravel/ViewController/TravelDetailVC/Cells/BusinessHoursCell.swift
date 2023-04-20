//
//  BusinessHoursCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/11.
//

import UIKit
import SnapKit

/// 營業時間
class BusinessHoursCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "營業時間"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var businessHoursLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    /// 箭頭圖標
    private lazy var arrowImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.right")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func convertCell(timeText: String) {
        businessHoursLabel.text = timeText
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(businessHoursLabel)
        contentView.addSubview(arrowImageView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
        }

        businessHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(20)
        }

        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
}
