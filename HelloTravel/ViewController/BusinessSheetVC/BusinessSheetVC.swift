//
//  BusinessSheetVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/23.
//

import UIKit
import SnapKit

class BusinessSheetVC: UIViewController {
    
    private lazy var viewModel: BusinessSheetVM = {
        var vm = BusinessSheetVM()
        return vm
    }()

    private lazy var sheetTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(SheetTableViewCell.self, forCellReuseIdentifier: "\(SheetTableViewCell.self)")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {

        view.backgroundColor = .bgLightBlue

        view.addSubview(sheetTableView)
        sheetTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func fetchSearchResults(travelList: [DisplayBusiness]) {
        viewModel.fetchSearchResults(travelList: travelList)
    }
}

// MARK: - tableView

extension BusinessSheetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.travelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SheetTableViewCell.self)", for: indexPath) as? SheetTableViewCell,
              let travelItem = viewModel.getTravelItem(indexPath: indexPath) else {
            Logger.log(message: "get cell error")
            return UITableViewCell()
        }

        cell.convertCell(image01: "testImage", image02: "testImage", image03: "testImage", title: travelItem.name, reviewCount: "\(travelItem.reviewCount)", starsstars: travelItem.rating)

        return cell
    }


}
