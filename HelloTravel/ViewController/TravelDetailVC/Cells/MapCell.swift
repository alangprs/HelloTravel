//
//  MapCell.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/11.
//

import UIKit
import SnapKit
import MapKit

class MapCell: UITableViewCell {

    private lazy var mapView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemRed
        return view
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "🚗 1分鐘 開車"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private lazy var addressLabel: UILabel = {
        var label = UILabel()
        label.text = "文化路一段270巷6號"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    /// 距離
    private lazy var distanceLabel: UILabel = {
        var label = UILabel()
        label.text = "300公尺"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(mapView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(distanceLabel)

        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(230)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
        }

        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(20)
        }

        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().inset(6)
        }

    }
}
