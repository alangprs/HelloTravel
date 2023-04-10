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
        tableView.addSubview(headerImageView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
//        tableView.register(SheetTableViewCell.self, forCellReuseIdentifier: "\(SheetTableViewCell.self)")
        return tableView
    }()

    private lazy var headerImageView: UIImageView = {
        var headerView = UIImageView()
        headerView.frame = CGRect.init(x: 0, y: -headerHeight, width: view.frame.width, height: headerHeight)
        headerView.contentMode = .scaleAspectFill
        headerView.clipsToBounds = true
        headerView.image = UIImage(named: "testImage")
        return headerView
    }()

    /// 預設 header 高度
    private lazy var headerHeight: CGFloat = {
        var height = 230.0
        return height
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return headerHeight
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let radius = -offsetY/headerHeight

        if (-offsetY > headerHeight) {
            headerImageView.transform = CGAffineTransform.init(scaleX: radius, y: radius)
            var frame = headerImageView.frame
            frame.origin.y = offsetY
            headerImageView.frame = frame
        }
    }
}
