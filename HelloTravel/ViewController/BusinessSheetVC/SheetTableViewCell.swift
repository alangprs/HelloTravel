//
//  SheetTableViewCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/23.
//

import UIKit
import SnapKit
import SwiftyStarRatingView

class SheetTableViewCell: UITableViewCell {

    // MARK: - image 區域

    private lazy var imageView01: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    /// 依照星星數量決定圖片
    private lazy var starsCountImageView: SwiftyStarRatingView = {
        var imageView = SwiftyStarRatingView()
        imageView.backgroundColor = .clear
        // 關閉使用者手勢
        imageView.isUserInteractionEnabled = false
        imageView.tintColor = .yellow
        return imageView
    }()

    /// 顯示星星數量文字
    private lazy var starsCountLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
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

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView01.layer.cornerRadius = 10
        imageView01.clipsToBounds = true
    }
    
    /// cell UI 設定
    /// - Parameters:
    ///   - image01: 照片1
    ///   - title: 抬頭文字
    ///   - reviewCount: 留言數量文字
    ///   - starsImage: 星星數量
    func convertCell(image01: String, title: String, reviewCount: String, starsstars: CGFloat) {
        
        sdWebImageAdapter.setImage(imageView: imageView01, imageString: image01)
        titleLabel.text = title
        starsCountLabel.text = "\(reviewCount)個評價"
        starsCountImageView.value = starsstars
    }

    private func setupUI() {
        contentView.backgroundColor = .bgLightBlue

        contentView.addSubview(imageView01)
        imageView01.addSubview(titleLabel)
        contentView.addSubview(starsCountImageView)
        contentView.addSubview(starsCountLabel)

        imageView01.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(imageView01.snp.width)
            make.bottom.equalTo(starsCountLabel.snp.top).inset(-6)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }

        starsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView01.snp.bottom).offset(12)
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
