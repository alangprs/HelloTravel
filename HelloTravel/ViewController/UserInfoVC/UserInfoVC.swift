//
//  UserInfoVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/17.
//

import UIKit
import SnapKit

class UserInfoVC: UIViewController {

    private lazy var viewModel: UserInfoVM = {
        var vm = UserInfoVM()
        return vm
    }()

    private lazy var userAvatarImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        return imageView
    }()

    private lazy var userNameLabel: UILabel = {
        var label = UILabel()
        label.text = "我是誰"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .regular)
        return label
    }()

    private lazy var listTableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserInfoCell.self, forCellReuseIdentifier: "\(UserInfoCell.self)")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.addSubview(userAvatarImageView)
        view.addSubview(userNameLabel)
        view.addSubview(listTableView)

        userAvatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaInsets).offset(60)
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(90)
        }

        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height / 2

        userNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(userAvatarImageView)
            make.leading.equalTo(userAvatarImageView.snp.trailing).offset(12)
        }

        listTableView.snp.makeConstraints { make in
            make.top.equalTo(userAvatarImageView.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func deleteAccount() {
        // TODO: 刪除帳號相關動作
        notifyAlert(title: "是否確認刪除帳號？", message: "帳號刪除之後，將無法恢復，點擊確認之後，帳號將會永久刪除")
    }

    private func singOut() {
        notifyAlert(title: "是否確認登出？", message: "點擊登出之後，將無法取得收藏頁面相關資訊") { [weak self] in
            self?.viewModel.singOut(completion: { result in
                switch result {
                    case .success(_):
                        // TODO: 回登入頁面
                        Logger.log(message: "返回登入頁面")
                    case .failure(let failure):
                        self?.notifyAlert(title: "登出失敗", message: failure.localizedDescription)
                }
            })
        }
    }

    /// 此頁各項通知 alert
    private func notifyAlert(title: String, message: String, okAction: (() -> Void)? = nil) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let action = okAction else {
                return
            }

            action()
        }

        let noAction = UIAlertAction(title: "取消", style: .cancel)

        alertControl.addAction(okAction)
        alertControl.addAction(noAction)
        present(alertControl, animated: true)
    }
}

// MARK: - TableView

extension UserInfoVC: UITableViewDelegate, UITableViewDataSource {

    /// 依照點選到cell 執行相關動作
    private func configureSelectCell(indexPath: IndexPath) {
        let cells = UserInfoType.allCases[indexPath.row]

        switch cells {

            case .dynamic:
                // TODO: 動態點擊後動作
                Logger.log(message: cells.typeTitle)
                break
            case .favorites:
                let vc = UserFavoritesVC()
                navigationController?.pushViewController(vc, animated: true)
            case .deleteAccount:
                deleteAccount()
                break
            case .signOut:
                singOut()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfoType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserInfoCell.self)", for: indexPath) as? UserInfoCell else {
            return UITableViewCell()
        }

        let typeTitle = UserInfoType.allCases[indexPath.row].typeTitle

        cell.convertCell(title: typeTitle)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        configureSelectCell(indexPath: indexPath)
    }
}
