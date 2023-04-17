//
//  FavoriteTableViewCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/27.
//

import UIKit
import SnapKit
import SwiftyStarRatingView

class FavoriteTableViewCell: UITableViewCell {

    // MARK: - image 區域

    // TODO: Image 與其他UI資料未接
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
    private lazy var starsCountImageView: SwiftyStarRatingView = {
        var imageView = SwiftyStarRatingView()
        imageView.backgroundColor = .clear
        // 關閉使用者手勢
        imageView.isUserInteractionEnabled = false
        imageView.tintColor = .yellow
        return imageView
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

    /// UI 參數注入
    func convertCell(title: String, image01URL: String, starsCount: Double) {
        titleLabel.text = title
        sdWebImageAdapter.setImage(imageView: imageView01, imageString: image01URL)
        starsCountImageView.value = CGFloat(starsCount)
    }
    
    private func setupUI() {
        contentView.backgroundColor = .brown

        contentView.addSubview(imageView01)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starsCountImageView)

        imageView01.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.width.height.equalTo(100)
            make.bottom.equalTo(titleLabel.snp.top).inset(-6)
        }

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
