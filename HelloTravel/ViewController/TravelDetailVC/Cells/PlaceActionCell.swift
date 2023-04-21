//
//  TravelDetailTableCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/10.
//

import UIKit
import SnapKit
import MapKit

/// 名稱、資訊、主要功能按鈕
class PlaceActionCell: UITableViewCell {
    
    private lazy var typeNameLabel: UILabel = {
        var label = UILabel()
        label.text = "日本料理"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    /// 營業時間
    private lazy var businessHoursLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    /// 全部時間按鈕
    private lazy var allBusinessHoursButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("查看全部時間 →", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        btn.addTarget(self, action: #selector(didClickAllBusinessHoursButton), for: .touchUpInside)
        return btn
    }()
    
    /// 註冊商店按鈕
    private lazy var registerStoreButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("註冊這商店", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 5
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        btn.addTarget(self, action: #selector(didClickRegisterStoreButton), for: .touchUpInside)
        return btn
    }()
    
    /// 新增評論
    private lazy var addCommentButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle("新增評論", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: .init(systemName: "square.and.pencil")!,targetSize: CGSize(width: 20, height: 20))
        btn.setImage(image, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(didClickAddCommentButton), for: .touchUpInside)
        return btn
    }()
    
    /// 新增照片
    private lazy var addPhotoButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle("新增照片", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: .init(systemName: "camera")!,targetSize: CGSize(width: 20, height: 20))
        btn.setImage(image, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(didClickAddPhotoButton), for: .touchUpInside)
        return btn
    }()
    
    /// 電話
    private lazy var callPhoneButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle("撥打電話", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: .init(systemName: "phone")!,targetSize: CGSize(width: 20, height: 20))
        btn.setImage(image, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(didClickCallPhoneButton), for: .touchUpInside)
        return btn
    }()
    
    /// 看地圖
    private lazy var lookMapButton: CategoryButton = {
        var btn = CategoryButton()
        btn.setTitle("開啟地圖", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let image = btn.resizeImage(image: .init(systemName: "map")!,targetSize: CGSize(width: 20, height: 20))
        btn.setImage(image, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(didClickLookMapButton), for: .touchUpInside)
        return btn
    }()
    
    // TODO: 暫時放這，思考一下資料結構如何處理
    
    // 目的地座標
    private lazy var lat: Double = 0
    private lazy var lon: Double = 0
    private lazy var placeName: String = ""
    
    /// 點擊顯示全部營業時間
    var didClickAllBusinessHours: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(lat: Double, lon: Double, placeName: String, businessHours: String) {
        self.lat = lat
        self.lon = lon
        self.placeName = placeName
        self.businessHoursLabel.text = businessHours
    }
    
    private func openMap() {
        // 將目標經緯度設為目標地點的經緯度
        let destinationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        // 創建一個 MKPlacemark，用於表示目標地點
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        // 創建一個 MKMapItem，用於打開地圖應用
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 設置目標地點的名稱
        destinationMapItem.name = placeName
        
        // 通過 launchOptions 選擇導航模式（例如：開車）
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        // 打開地圖應用並開始導航
        destinationMapItem.openInMaps(launchOptions: launchOptions)
    }
    
    private func setupUI() {
        
        contentView.addSubview(typeNameLabel)
        contentView.addSubview(businessHoursLabel)
        contentView.addSubview(allBusinessHoursButton)
        contentView.addSubview(registerStoreButton)
        
        typeNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(25)
        }
        
        businessHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(typeNameLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(25)
        }
        
        allBusinessHoursButton.snp.makeConstraints { make in
            make.top.equalTo(businessHoursLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(25)
        }
        
        registerStoreButton.snp.makeConstraints { make in
            make.top.equalTo(allBusinessHoursButton.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        // MARK: 中間按鈕
        
        contentView.addSubview(addCommentButton)
        contentView.addSubview(addPhotoButton)
        contentView.addSubview(callPhoneButton)
        contentView.addSubview(lookMapButton)
        
        let leading = 20
        let bottom = 10
        
        addCommentButton.snp.makeConstraints { make in
            make.top.equalTo(registerStoreButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(24)
            make.leading.equalToSuperview().multipliedBy(4.1)
            make.height.equalTo(57)
            make.bottom.equalToSuperview().inset(bottom)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(addCommentButton)
            make.leading.equalTo(addCommentButton.snp.trailing).offset(leading)
            make.width.height.equalTo(addCommentButton)
            make.bottom.equalToSuperview().inset(bottom)
        }
        
        callPhoneButton.snp.makeConstraints { make in
            make.top.equalTo(addCommentButton)
            make.leading.equalTo(addPhotoButton.snp.trailing).offset(leading)
            make.width.height.equalTo(addCommentButton)
            make.bottom.equalToSuperview().inset(bottom)
        }
        
        lookMapButton.snp.makeConstraints { make in
            make.top.equalTo(addCommentButton)
            make.leading.equalTo(callPhoneButton.snp.trailing).offset(leading)
            make.width.height.equalTo(addCommentButton)
            make.bottom.equalToSuperview().inset(bottom)
        }
        
    }
    
    // MARK: - action
    
    /// 點擊觀看更多按鈕
    @objc private func didClickAllBusinessHoursButton() {
        // TODO: 看更多時間按鈕動作
        didClickAllBusinessHours?()
    }
    
    @objc private func didClickRegisterStoreButton() {
        // TODO: 註冊商店動作
    }
    
    /// 新增評論
    @objc private func didClickAddCommentButton() {
        
    }
    /// 新增照片
    @objc private func didClickAddPhotoButton() {
        
    }
    
    /// 電話
    @objc private func didClickCallPhoneButton() {
        
    }
    
    /// 看地圖
    @objc private func didClickLookMapButton() {
        openMap()
    }
    
}
