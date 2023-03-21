//
//  NearbyLandmarkVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/17.
//

import UIKit
import SnapKit

/// 依照座標顯顯示周圍景點
class NearbyLandmarkVC: UIViewController {
    
    private lazy var viewModel: NearbyLandmarkVM = {
        var vm = NearbyLandmarkVM()
        vm.delegate = self
        return vm
    }()
    
    // MARK: - 最上方區域
    private lazy var topView: UIView = {
        var view = UIView()
        return view
    }()
    
    private lazy var bgImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "KabdnarkTop")
        return imageView
    }()
    
    private lazy var topTitleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "你周圍的餐廳、景點"
        return label
    }()
    
    // MARK: - 搜尋匡
    
    private lazy var textView: UITextField = {
        var textView = UITextField()
        textView.placeholder = "請輸入文字"
        textView.borderStyle = .roundedRect
        textView.delegate = self
        return textView
    }()
    
    // MARK: - 按鈕區
    
    /// 按鈕容器
    private lazy var middleButtonContainerView: UIView = {
        var view = UIView()
        return view
    }()
    
    /// 餐廳
    private lazy var restaurantButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle("餐廳", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: UIImage(named: "icon_restaurant")!,targetSize: CGSize(width: 20, height: 20))
        btn.setImage(image, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(clickRestaurantButton), for: .touchUpInside)
        return btn
    }()
    
    /// 按摩
    private lazy var massageButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle("按摩", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: UIImage(named: "icon_massage")!,targetSize: CGSize(width: 20, height: 20))
        btn.setImage(image, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(clickMassageButton), for: .touchUpInside)
        return btn
    }()
    
    /// 旅遊
    private lazy var travelButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle("旅遊", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: UIImage(named: "icon_travel")!,targetSize: CGSize(width: 20, height: 20))
        btn.setImage(image, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(clickTravelButton), for: .touchUpInside)
        return btn
    }()

    /// 圖片下載器
    private lazy var sdWebImageAdapter: SDWebImageAdapter = {
        return SDWebImageAdapter()
    }()
    
    // MARK: - 附近景點清單
    
    private lazy var travelCollectionView: UICollectionView = {
        var collectionView = UICollectionView()
        return collectionView
    }()
    
    // MARK: - 生命週期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        viewModel.askPermission()
    }
    
    // MARK: - 其他
    
    private func setupUI() {
        setupTopView()
        setupMiddleButtonContainerView()
        setupSearchBar()
        setupCollectionView()
    }
    
    /// 搜尋匡
    private func setupSearchBar() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().offset(-12)
            let height = 50
            make.height.equalTo(height)
            let half = height / 2
            make.bottom.equalTo(topView.snp.bottom).offset(half)
        }
    }
    
    private func setupTopView() {
        view.addSubview(topView)
        topView.backgroundColor = .systemRed
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(280)
        }
        
        topView.addSubview(bgImage)
        bgImage.backgroundColor = .systemGray
        topView.addSubview(topTitleLabel)
        
        bgImage.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(12)
        }
    }
    
    /// 按鈕群
    private func setupMiddleButtonContainerView() {
        // TODO: - UI 再調整
        
        view.addSubview(middleButtonContainerView)
        middleButtonContainerView.addSubview(restaurantButton)
        middleButtonContainerView.addSubview(massageButton)
        middleButtonContainerView.addSubview(travelButton)
        
        middleButtonContainerView.backgroundColor = .systemRed
        
        middleButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        restaurantButton.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.leading.equalToSuperview().offset(16)
        }
        
        massageButton.snp.makeConstraints { make in
            make.leading.equalTo(restaurantButton.snp.trailing).offset(30)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        travelButton.snp.makeConstraints { make in
            make.leading.equalTo(massageButton.snp.trailing).offset(30)
            make.bottom.equalToSuperview().offset(-12)
        }
        
    }
    
    /// CollectionView 相關設定
    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        let getWidth = view.frame.width
        /// vc 剩餘高度
        let lastHeight: CGFloat = {
            let superViewHeight = view.frame.height
            let topViewHeight = topView.frame.height
            let buttonContainerViewHeight = middleButtonContainerView.frame.height
            return superViewHeight - (topViewHeight + buttonContainerViewHeight)
        }()
        
        layout.itemSize = CGSize(width: getWidth, height: lastHeight)
        // 左右間距
        layout.minimumLineSpacing = CGFloat(integerLiteral: 10)
        // 水平滑動
        layout.scrollDirection = .horizontal
        
        travelCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // 關閉滾動條
        travelCollectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(travelCollectionView)
        
        travelCollectionView.delegate = self
        travelCollectionView.dataSource = self
        
        travelCollectionView.register(TravelCollectionViewCell.self, forCellWithReuseIdentifier: "\(TravelCollectionViewCell.self)")
        travelCollectionView.snp.makeConstraints { make in
            make.top.equalTo(middleButtonContainerView.snp.bottom).inset(0.5)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    /// 未開啟定位通知
    private func locationAlert(title: String, message: String) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        alertControl.addAction(okAction)
        present(alertControl, animated: true)
    }
    
    /// cell UI 設定
    /// - Parameters:
    ///   - bgImageName: 背景圖名稱
    ///   - title: 景點名稱
    ///   - starsCount: 星星數量
    private func convertCell(cell: TravelCollectionViewCell, bgImageURL: String, title: String, starsCount: Double) {
        sdWebImageAdapter.setImage(imageView: cell.bgImageView, imageString: bgImageURL)
        cell.titleLabel.text = title
        cell.starsCountLabel.text = "\(starsCount)"
        cell.starsCountImageView.image = viewModel.calculateStarIcon(starsCount: starsCount)
    }
    
    // MARK: - action
    
    @objc private func clickRestaurantButton() {
        // TODO: 點擊後動作
        Logger.log(message: "clickRestaurantButton")
    }
    
    @objc private func clickMassageButton() {
        // TODO: 點擊後動作
        Logger.log(message: "clickMassageButton")
    }
    
    @objc private func clickTravelButton() {
        // TODO: 點擊後動作
        Logger.log(message: "clickTravelButton")
    }
    
}

// MARK: - NearbyLandmarkVMDelegate

extension NearbyLandmarkVC: NearbyLandmarkVMDelegate {
    func getTravelItemSuccess() {
        
        DispatchQueue.main.async {
            self.travelCollectionView.reloadData()
        }
    }
    
    func getTravelItemError() {
        // TODO: error 處理
    }
    
    func noGPSPermission() {
        locationAlert(title: "未開開啟定位服務", message: "請前往 設定 > 隱私權 > 定位服務，開啟")
    }
}

// MARK: - UITextFieldDelegate

extension NearbyLandmarkVC: UITextFieldDelegate {
    // TODO: - 文字擷取
}

// MARK: - CollectionView

extension NearbyLandmarkVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.travelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = travelCollectionView.dequeueReusableCell(withReuseIdentifier: "\(TravelCollectionViewCell.self)", for: indexPath) as? TravelCollectionViewCell,
              let travelItem = viewModel.getTravelItem(indexPath: indexPath) else {
            
            Logger.errorLog(message: "get CollectionViewCell error")
            return UICollectionViewCell()
        }
        
        convertCell(cell: cell, bgImageURL: travelItem.imageURL, title: travelItem.name, starsCount: travelItem.rating)
        
        return cell
    }
    
    
}

