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
    
    private lazy var imageView02: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "testImage")
        return imageView
    }()
    
    private lazy var imageView03: UIImageView = {
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

    /// 顯示星星數量文字
    private lazy var starsCountLabel: UILabel = {
        var label = UILabel()
        return label
    }()

    /// 圖片下載器
    private lazy var sdWebImageAdapter: SDWebImageAdapter = {
        return SDWebImageAdapter()
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// cell UI 設定
    /// - Parameters:
    ///   - image01: 照片1
    ///   - image02: 照片2
    ///   - image03: 照片3
    ///   - title: 抬頭文字
    ///   - starsCount: 星星數量文字
    ///   - starsImage: 星星圖片
    func convertCell(image01: String, image02: String, image03: String, title: String, starsCount: String, starsImage: UIImage) {
        
        sdWebImageAdapter.setImage(imageView: imageView01, imageString: image01)
        sdWebImageAdapter.setImage(imageView: imageView02, imageString: image02)
        sdWebImageAdapter.setImage(imageView: imageView03, imageString: image03)
        titleLabel.text = title
        starsCountLabel.text = starsCount
        starsCountImageView.image = starsImage
    }

    private func setupUI() {
        contentView.backgroundColor = .yellow

        contentView.addSubview(imageView01)
        contentView.addSubview(imageView02)
        contentView.addSubview(imageView03)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starsCountImageView)
        contentView.addSubview(starsCountLabel)

        imageView01.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(imageView01.snp.width)
            make.bottom.equalTo(titleLabel.snp.top).inset(-6)
        }
        
        imageView02.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalTo(imageView01.snp.trailing).inset(-9)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(imageView02.snp.width)
            make.bottom.equalTo(titleLabel.snp.top).inset(-6)
        }
        
        imageView03.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(imageView03.snp.width)
            make.bottom.equalTo(titleLabel.snp.top).inset(-6)
        }

        titleLabel.text = "咖啡吧"
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
        }

        starsCountLabel.text = "5656"
        starsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-6)
        }

        starsCountImageView.snp.makeConstraints { make in
            make.leading.equalTo(starsCountLabel.snp.trailing).inset(-6)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(titleLabel.snp.height)
            make.centerY.equalTo(starsCountLabel.snp.centerY)
        }

    }
}
