//
//  TravelCollectionViewCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/17.
//

import UIKit
import SnapKit

class TravelCollectionViewCell: UICollectionViewCell {

    private lazy var bgImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()

    /// 景點名稱
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        return label
    }()

    /// 依照星星數量決定圖片
    private lazy var starsCountImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()

    /// 顯示星星數量文字
    private lazy var starsCountLabel: UILabel = {
        var label = UILabel()
        return label
    }()

    private lazy var likeButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.addTarget(self, action: #selector(didClickLikeButton), for: .touchUpInside)
        return btn
    }()

    /// 圖片下載器
    private lazy var sdWebImageAdapter: SDWebImageAdapter = {
        return SDWebImageAdapter()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// cell UI 設定
    /// - Parameters:
    ///   - bgImage: 背景圖
    ///   - title: 名稱
    ///   - starsCount: 星星數量
    ///   - starsImage: 星星圖
    func convertCell(bgImage: String, title: String, starsCount: Double, starsImage: UIImage) {
        sdWebImageAdapter.setImage(imageView: bgImageView, imageString: bgImage)
        titleLabel.text = title
        starsCountLabel.text = "\(starsCount)"
        starsCountImageView.image = starsImage
    }

    // MARK: - action

    @objc private func didClickLikeButton() {
        Logger.log(message: "按鈕被點擊")
        // TODO: 點擊後事件
    }

    // MARK: - UI 設定

    private func setupUI() {
        contentView.backgroundColor = .green

        contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }

        bgImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(14)
        }

        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(16)
            make.leading.equalTo(14)
        }

        contentView.addSubview(starsCountImageView)
        starsCountImageView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(16)
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
        }

        contentView.addSubview(starsCountLabel)
        starsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(16)
            make.leading.equalTo(starsCountImageView.snp.trailing).offset(10)
        }
    }

}
