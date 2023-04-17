//
//  UserFavoritesVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/27.
//

import UIKit
import SnapKit

class UserFavoritesVC: UIViewController {

    private lazy var viewModel: UserFavoritesVM = {
        var vm = UserFavoritesVM()
        vm.delegate = self
        return vm
    }()

    private lazy var favoriteTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "\(FavoriteTableViewCell.self)")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.referenceData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.removeAllObservers()
    }

    private func setupUI() {
        view.addSubview(favoriteTableView)

        favoriteTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

}

// MARK: - TableView

extension UserFavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.likeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FavoriteTableViewCell.self)", for: indexPath) as? FavoriteTableViewCell,
              let likeItem = viewModel.getLikeItem(index: indexPath) else {
            Logger.errorLog(message: "get cell error")
            return UITableViewCell()
        }

        cell.convertCell(title: likeItem.name, image01URL: likeItem.imageURL, starsCount: likeItem.rating)

        return cell
    }

}

// MARK: - UserFavoritesVMDelegate

extension UserFavoritesVC: UserFavoritesVMDelegate {
    func getLikeListSuccess() {
        favoriteTableView.reloadData()
    }

}
