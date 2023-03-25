//
//  BusinessSheetVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/23.
//

import UIKit
import SnapKit

class BusinessSheetVC: UIViewController {

    private lazy var sheetTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SheetTableViewCell.self, forCellReuseIdentifier: "\(SheetTableViewCell.self)")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {

        view.backgroundColor = .systemRed

        view.addSubview(sheetTableView)
        sheetTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension BusinessSheetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SheetTableViewCell.self)", for: indexPath) as? SheetTableViewCell else {
            Logger.log(message: "get cell error")
            return UITableViewCell()
        }

        return cell
    }


}
