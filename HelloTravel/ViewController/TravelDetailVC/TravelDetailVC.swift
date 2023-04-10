//
//  TravelDetailVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/10.
//

import UIKit
import SnapKit

class TravelDetailVC: UIViewController {

    private lazy var detailTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(headerImageView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
//        tableView.register(SheetTableViewCell.self, forCellReuseIdentifier: "\(SheetTableViewCell.self)")
        return tableView
    }()

    private lazy var headerImageView: UIImageView = {
        var headerView = UIImageView()
        headerView.frame = CGRect.init(x: 0, y: -headerHeight, width: view.frame.width, height: headerHeight)
        headerView.contentMode = .scaleAspectFill
        headerView.clipsToBounds = true
        headerView.image = UIImage(named: "testImage")
        return headerView
    }()

    /// 返回按鈕
    private lazy var backButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("返回", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        btn.tintColor = .white
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(didClickBackButton), for: .touchUpInside)
        return btn
    }()

    /// 喜歡按鈕
    private lazy var likeButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(didClickLikeButton), for: .touchUpInside)
        return btn
    }()

    /// 分享按鈕
    private lazy var shareButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(didClickShareButton), for: .touchUpInside)
        return btn
    }()

    /// 更多按鈕
    private lazy var moreButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(didClickMoreButton), for: .touchUpInside)
        return btn
    }()

    /// 預設 header 高度
    private lazy var headerHeight: CGFloat = {
        var height = 230.0
        return height
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "測試抬頭"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
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
        label.text = "56"
        label.textColor = .white
        return label
    }()

    /// 更多圖片按鈕
    private lazy var moreImageButton: UIButton = {
        var btn = UIButton()
        btn.setTitle(" 觀看更多圖片 ", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.titleLabel?.textColor = .white
        btn.backgroundColor = .brown.withAlphaComponent(0.5)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(didClickMoreImageButton), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setupUI() {
        view.addSubview(detailTableView)
        headerImageView.addSubview(backButton)
        headerImageView.addSubview(moreButton)
        headerImageView.addSubview(shareButton)
        headerImageView.addSubview(likeButton)
        headerImageView.addSubview(titleLabel)
        headerImageView.addSubview(starsCountImageView)
        headerImageView.addSubview(starsCountLabel)
        headerImageView.addSubview(titleLabel)
        headerImageView.addSubview(moreImageButton)

        detailTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(25)
        }

        moreButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-25)
        }

        shareButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalTo(moreButton.snp.leading).offset(-20)
        }

        likeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalTo(shareButton.snp.leading).offset(-20)
        }

        starsCountImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(30)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(25)
        }

        starsCountLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalTo(starsCountImageView.snp.trailing).offset(10)
        }

        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(starsCountImageView.snp.top).offset(-12)
            make.leading.equalToSuperview().offset(30)
        }

        moreImageButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(-40)
        }
    }

    // MARK: - action

    /// 返回按鈕
    @objc private func didClickBackButton() {
        // TODO: 返回按鈕動作
    }

    /// 更多按鈕
    @objc private func didClickMoreButton() {
        // TODO: 更多按鈕動作
    }

    /// 分享按鈕
    @objc private func didClickShareButton() {
        // TODO: 分享按鈕動作
    }

    /// 喜歡按鈕
    @objc private func didClickLikeButton() {
        // TODO: 喜歡按鈕動作
    }

    /// 更多圖片按鈕
    @objc private func didClickMoreImageButton() {
        // TODO: 更多圖片按鈕動作
    }
}

// MARK: - tableView

extension TravelDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return headerHeight
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let radius = -offsetY/headerHeight

        if (-offsetY > headerHeight) {
            headerImageView.transform = CGAffineTransform.init(scaleX: radius, y: radius)
            var frame = headerImageView.frame
            frame.origin.y = offsetY
            headerImageView.frame = frame
        }
    }
}
