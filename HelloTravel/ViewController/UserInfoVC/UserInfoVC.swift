//
//  UserInfoVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/17.
//

import UIKit
import SnapKit

class UserInfoVC: UIViewController {

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
}

// MARK: - TableView

extension UserInfoVC: UITableViewDelegate, UITableViewDataSource {
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


}
