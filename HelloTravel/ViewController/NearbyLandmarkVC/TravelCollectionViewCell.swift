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
        label.font = .systemFont(ofSize: 16, weight: .bold)
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
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private lazy var likeButton: UIButton = {
        var btn = UIButton()
        btn.tintColor = .red
        btn.addTarget(self, action: #selector(didClickLikeButton), for: .touchUpInside)
        return btn
    }()

    /// 圖片下載器
    private lazy var sdWebImageAdapter: SDWebImageAdapter = {
        return SDWebImageAdapter()
    }()

    /// 按鈕點擊事件
    var didClickButton: ((Int) -> Void)?

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
    ///   - isFavorite: 是否有被收藏
    func convertCell(bgImage: String, title: String, starsCount: Double, starsImage: UIImage, isFavorite: Bool, buttonTag: Int) {
        sdWebImageAdapter.setImage(imageView: bgImageView, imageString: bgImage)
        titleLabel.text = title
        starsCountLabel.text = "\(starsCount)"
        starsCountImageView.image = starsImage
        setLikeButtonImage(isFavorite: isFavorite)
        likeButton.tag = buttonTag
    }

    /// 判斷收藏按鈕圖片狀態
    private func setLikeButtonImage(isFavorite: Bool) {
        if isFavorite {
            likeButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }

    }

    // MARK: - action

    @objc private func didClickLikeButton() {
        Logger.log(message: "按鈕\(likeButton.tag)被點擊")
        // TODO: 點擊後事件
        didClickButton?(likeButton.tag)
    }

    // MARK: - UI 設定

    private func setupUI() {

        contentView.addSubview(bgImageView)
        bgImageView.addSubview(titleLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(starsCountImageView)
        contentView.addSubview(starsCountLabel)

        bgImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(14)
        }

        likeButton.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(16)
            make.leading.equalTo(14)
        }

        starsCountImageView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(12)
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
        }

        starsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(16)
            make.leading.equalTo(starsCountImageView.snp.trailing).offset(10)
        }
    }

}
