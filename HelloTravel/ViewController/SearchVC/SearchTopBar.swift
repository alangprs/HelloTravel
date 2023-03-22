//
//  SearchTopBar.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/21.
//

import UIKit
import SnapKit

protocol SearchTopBarViewDelegate: AnyObject {
    /// 返回上一頁
    func goBackViewController()
    /// 顯示地圖 OR 列表清單
    func didTypeSwitch()
}

/// 搜尋欄位 View
class SearchTopBarView: UIView {

    weak var delegate: SearchTopBarViewDelegate?

    private lazy var backButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        btn.addTarget(self, action: #selector(didClickBackButton), for: .touchUpInside)
        return btn
    }()

    private lazy var searchTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "輸入想搜尋內容 ex: 咖啡廳、飯店"
        textField.delegate = self
        return textField
    }()

    private lazy var typeSwitchButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "list.dash"), for: .normal)
        btn.addTarget(self, action: #selector(didClickTypeSwitchButton), for: .touchUpInside)
        return btn
    }()
    
    init(searchType: CategoryType) {
        super.init(frame: .zero)
        
        setupUI()
        searchTextField.text = searchType.typeTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        backgroundColor = .white
        addSubview(backButton)
        addSubview(searchTextField)
        addSubview(typeSwitchButton)

        backButton.snp.makeConstraints { make in
            make.centerY.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.width.equalTo(30)
        }

        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(6)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        typeSwitchButton.snp.makeConstraints { make in
            make.centerY.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.width.equalTo(30)
        }
    }

    // MARK: - Action

    @objc private func didClickBackButton() {
        /// TODO: 返回上一頁動作
        Logger.log(message: "didClickBackButton")
        delegate?.goBackViewController()
    }

    @objc private func didClickTypeSwitchButton() {
        /// TODO: 狀態切換
        Logger.log(message: "didClickTypeSwitchButton")
        delegate?.didTypeSwitch()
    }
}

// MARK: - UITextFieldDelegate

extension SearchTopBarView: UITextFieldDelegate {
    // TODO: textField 相關設定
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.searchTextField.endEditing(true)
        
        return true
    }
}
