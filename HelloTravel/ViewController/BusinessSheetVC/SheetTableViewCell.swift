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
        imageView.image = UIImage(named: "testImage")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
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

        contentView.addSubview(imageView01)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starsCountImageView)

        imageView01.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.width.height.equalTo(100)
            make.bottom.equalTo(titleLabel.snp.top).inset(-6)
        }
        
        titleLabel.text = "咖啡吧"
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-6)
        }

        starsCountImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).inset(-6)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(titleLabel.snp.height)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

    }
}
