//
//  TravelDetailVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/10.
//

import UIKit
import SnapKit

class TravelDetailVC: UIViewController {

    private var viewModel: TravelDetailVM?

    // MARK: - UI 元件

    private lazy var detailTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(headerImageView)
        // 添加 20 作為額外的間距，避免最下方被擋住
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let bottomInset = tabBarHeight + 20
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: bottomInset, right: 0)
        registerCell(tableView: tableView)
        return tableView
    }()

    private lazy var headerImageView: UIImageView = {
        var headerView = UIImageView()
        headerView.frame = CGRect.init(x: 0, y: -headerHeight, width: view.frame.width, height: headerHeight)
        headerView.contentMode = .scaleAspectFill
        headerView.clipsToBounds = true
        headerView.image = UIImage(named: "testImage")
        headerView.isUserInteractionEnabled = true
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

    init(travelItem: DisplayBusiness) {
        self.viewModel = TravelDetailVM(travelItem: travelItem)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 生命週期

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupHeaderDetail()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
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

    /// 設定 header 區域資料
    private func setupHeaderDetail() {
        guard let travelItem = viewModel?.travelItem else { return }
        titleLabel.text = travelItem.name
        starsCountLabel.text = "\(travelItem.rating)"
        setLikeButtonImage(isFavorite: travelItem.isFavorites)
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

    /// 返回按鈕
    @objc private func didClickBackButton() {
        navigationController?.popViewController(animated: true)
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

    private func registerCell(tableView: UITableView) {
        tableView.register(PlaceActionCell.self, forCellReuseIdentifier: "\(PlaceActionCell.self)")
        tableView.register(BusinessHoursCell.self, forCellReuseIdentifier: "\(BusinessHoursCell.self)")
        tableView.register(PhoneCell.self, forCellReuseIdentifier: "\(PhoneCell.self)")
        tableView.register(MapCell.self, forCellReuseIdentifier: "\(MapCell.self)")
    }
    
    private func configureCell(for sectionType: TravelDetailSectionType, indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        switch sectionType {
            case .topArea:
                return UITableViewCell()

            case .placeAction:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PlaceActionCell.self)", for: indexPath) as? PlaceActionCell else {
                    return UITableViewCell()
                }

                return cell

            case .information:
                return configureInformationCell(at: indexPath, tableView: tableView)
        }
    }

    /// cell 增加方式：增加 InformationCellType case 
    /// 加入新 cell 時，numberOfRowsInSection 要增加數量
    private func configureInformationCell(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cellType = InformationCellType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }

        switch cellType {
            case .businessHours:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BusinessHoursCell.self)", for: indexPath) as? BusinessHoursCell else {
                    return UITableViewCell()
                }

                return cell
            case .phone:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PhoneCell.self)", for: indexPath) as? PhoneCell else {
                    return UITableViewCell()
                }

                return cell
            case .map:
                guard let mapCell = tableView.dequeueReusableCell(withIdentifier: "\(MapCell.self)", for: indexPath) as? MapCell else {
                    return UITableViewCell()
                }

                let userLat = 1.2938
                let userLon = 103.841114

                let destinationLat = 1.284066
                let destinationLon = 103.841114

                // TODO: 座標等確定後接上實際座標
                viewModel?.calculateDistanceAndETA(userLat: userLat, userLon: userLon,
                                                   destinationLat: destinationLat, destinationLon: destinationLon, completion: { distance, travelTime, error in
                    guard let distance = distance,
                          let travelTime = travelTime,
                          let address = self.viewModel?.assembleAddress() else { return }

                    mapCell.convertCell(userLat: userLat, userLon: userLon,
                                        destinationLat: destinationLat, destinationLon: destinationLon,
                                        navigateTime: "\(travelTime)分鐘開車",
                                        distance: "\(distance)公尺",
                                        address: address)
                })
                return mapCell
        }
    }

    /// 控制點選到的 cell
    private func configureSelectInformationCell(indexPath: IndexPath) {
        guard let section = TravelDetailSectionType(rawValue: indexPath.section),
              section == .information,
              let cellType = InformationCellType(rawValue: indexPath.row) else {
            return
        }

        switch cellType {
            case .businessHours:
                return
            case .phone:
                callPhoneNumber()
            case .map:
                return
        }

    }

    /// 撥打電話
    private func callPhoneNumber() {
        guard let phoneNumber = viewModel?.travelItem?.phone,
              let phoneURL = URL(string: "tel://\(phoneNumber)") else { return }

        if UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL)
        } else {
            Logger.errorLog(message: "無法撥打電話")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        configureSelectInformationCell(indexPath: indexPath)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return TravelDetailSectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let sectionType = TravelDetailSectionType(rawValue: section) else {
            return 0
        }

        // 返回每個 section 需要的 cell 數量
        switch sectionType {
            case .topArea:
                return 0
            case .placeAction:
                return 1
            case .information:
                return 3
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let sectionType = TravelDetailSectionType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        return configureCell(for: sectionType, indexPath: indexPath, tableView: tableView)

    }

    /// 依照 section 返回指定 headerView 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        guard let sectionType = TravelDetailSectionType(rawValue: section) else {
            return 0
        }

        switch sectionType {
            case .topArea:
                return headerHeight
            case .placeAction:
                return 0
            case .information:
                return 30
        }
    }
}
