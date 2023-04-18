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
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "testImage")
        return imageView
    }()
    
    private lazy var topTitleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.text = "New and popular\nin Nearby"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()

    // MARK: - 按鈕區

    /// 搜尋按鈕
    private lazy var searchButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.setTitle("搜尋你感興趣的地點", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.backgroundColor = .white
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        btn.setTitleColor(.myLightBlue, for: .normal)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(didClickSearchButton), for: .touchUpInside)
        return btn
    }()
    
    /// 按鈕容器
    private lazy var middleButtonContainerView: UIView = {
        var view = UIView()
        return view
    }()
    
    /// 餐廳
    private lazy var restaurantButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle(CategoryType.restaurant.typeTitle, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: UIImage(named: "icon_restaurant")!,targetSize: CGSize(width: 20, height: 20))
        let tintedImage = image.withTintColor(.myLightBlue, renderingMode: .alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.setTitleColor(.myLightBlue, for: .normal)
        btn.addTarget(self, action: #selector(clickRestaurantButton), for: .touchUpInside)
        return btn
    }()
    
    /// 按摩
    private lazy var massageButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle(CategoryType.massage.typeTitle, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: UIImage(named: "icon_massage")!,targetSize: CGSize(width: 20, height: 20))
        let tintedImage = image.withTintColor(.myLightBlue, renderingMode: .alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.setTitleColor(.myLightBlue, for: .normal)
        btn.addTarget(self, action: #selector(clickMassageButton), for: .touchUpInside)
        return btn
    }()
    
    /// 旅遊
    private lazy var travelButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle(CategoryType.travel.typeTitle, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: UIImage(named: "icon_travel")!,targetSize: CGSize(width: 20, height: 20))
        let tintedImage = image.withTintColor(.myLightBlue, renderingMode: .alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.setTitleColor(.myLightBlue, for: .normal)
        btn.addTarget(self, action: #selector(clickTravelButton), for: .touchUpInside)
        return btn
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
        
        viewModel.askPermission()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.removeAllObservers()
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
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
        topView.addSubview(bgImage)
        topView.addSubview(topTitleLabel)

        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(280)
        }

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
        
        middleButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        massageButton.snp.makeConstraints { make in
            make.top.equalTo(60)
            make.centerX.equalToSuperview()
        }

        restaurantButton.snp.makeConstraints { make in
            make.centerY.equalTo(massageButton)
            make.leading.equalToSuperview().offset(40)
        }

        travelButton.snp.makeConstraints { make in
            make.centerY.equalTo(restaurantButton)
            make.trailing.equalToSuperview().offset(-40)
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
        travelCollectionView.backgroundColor = .clear
        
        travelCollectionView.delegate = self
        travelCollectionView.dataSource = self
        
        travelCollectionView.register(TravelCollectionViewCell.self, forCellWithReuseIdentifier: "\(TravelCollectionViewCell.self)")
        travelCollectionView.snp.makeConstraints { make in
            make.top.equalTo(middleButtonContainerView.snp.bottom).inset(0.5)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-6)
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
    
    /// 跳轉地圖頁面
    /// - Parameter categoryType: 搜尋狀態
    private func presentToSearchVC(categoryType: CategoryType) {

        let navigationVC = UINavigationController(rootViewController: SearchVC(searchType: categoryType))
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }

    /// cell 點擊事件
    private func configurationCellEvent(cell: TravelCollectionViewCell) {
        cell.didClickButton = { [weak self] (tag) in

            guard let self = self else { return }
            self.viewModel.toggleLikeStatus(tag: tag)
        }
    }
    
    // MARK: - action
    
    @objc private func didClickSearchButton() {
        presentToSearchVC(categoryType: .none)
    }
    
    @objc private func clickRestaurantButton() {
        presentToSearchVC(categoryType: .restaurant)
    }
    
    @objc private func clickMassageButton() {
        presentToSearchVC(categoryType: .massage)
    }
    
    @objc private func clickTravelButton() {
        presentToSearchVC(categoryType: .travel)
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

        cell.convertCell(bgImage: travelItem.imageURL,
                         title: travelItem.name,
                         starsCount: travelItem.rating,
                         isFavorite: travelItem.isFavorites,
                         buttonTag: indexPath.row)
        configurationCellEvent(cell: cell)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectItem = viewModel.travelList[indexPath.row]
        let travelDetailVC = TravelDetailVC(travelItem: selectItem)

        navigationController?.pushViewController(travelDetailVC, animated: true)
    }
    
    
}

