//
//  TravelTableViewCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/17.
//

import UIKit
import SnapKit

class TravelCollectionViewCell: UICollectionViewCell {

    lazy var bgImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()

    /// 景點名稱
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        return label
    }()

    /// 依照星星數量決定圖片
    lazy var starsCountImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()

    /// 顯示星星數量文字
    lazy var starsCountLabel: UILabel = {
        var label = UILabel()
        return label
    }()

    private lazy var likeButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.addTarget(self, action: #selector(didClickLikeButton), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
