//
//  UserInfoCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/17.
//

import UIKit
import SnapKit

class UserInfoCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func convertCell(title: String) {
        titleLabel.text = title
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
        }
    }
}
