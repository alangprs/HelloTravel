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
//        tableView.register(SheetTableViewCell.self, forCellReuseIdentifier: "\(SheetTableViewCell.self)")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.addSubview(detailTableView)
        detailTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: -

extension TravelDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()
    }


}
