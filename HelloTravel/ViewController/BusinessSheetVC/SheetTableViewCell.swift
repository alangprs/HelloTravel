//
//  SheetTableViewCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/23.
//

import UIKit
import SnapKit

class SheetTableViewCell: UITableViewCell {

    // MARK: - image 區域

    private lazy var imageView01: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "1.circle")
        return imageView
    }()

    private lazy var imageView02: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "2.circle")
        return imageView
    }()

    private lazy var imageView03: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "3.circle")
        return imageView
    }()

    private lazy var imageStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [imageView01, imageView02, imageView03])
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "咖啡"
        return label
    }()

    /// 依照星星數量決定圖片
    private lazy var starsCountImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .green
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
        contentView.backgroundColor = .yellow

        contentView.addSubview(imageStackView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starsCountImageView)

        imageStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().offset(6)
            make.width.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageStackView).offset(6)
            make.leading.equalToSuperview().offset(6)
        }

        starsCountImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(4)
            make.leading.equalToSuperview().offset(6)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.bottom.equalToSuperview().offset(6)
        }

    }
}
