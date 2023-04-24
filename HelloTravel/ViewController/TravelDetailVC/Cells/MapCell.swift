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

    private lazy var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.delegate = self
        return mapView
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
        label.text = "未取得地址"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    /// 距離
    private lazy var distanceLabel: UILabel = {
        var label = UILabel()
        label.text = "未取得距離"
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

    /// cell資料注入
    /// - Parameters:
    ///   - userLat: 使用者目前緯度
    ///   - userLon: 使用者目前經度
    ///   - destinationLat: 目的地緯度
    ///   - destinationLon: 目的地經度
    ///   - navigateTime: 導航時間
    ///   - distance: 距離(單位公尺)
    ///   - address: 地址
    func convertCell(userLat: Double, userLon: Double, destinationLat: Double, destinationLon: Double, navigateTime: String, distance: String, address: String) {
        setupInitialRegion(lat: userLat, lon: userLon)
        addAnnotations(userLat: userLat, userLon: userLon,
                       destinationLat: destinationLat, destinationLon: destinationLon)
        calculateAndDrawRoute()
        titleLabel.text = "🚗 \(navigateTime)"
        addressLabel.text = address
        distanceLabel.text = "\(distance)公里"
    }

    /// 設置初始地圖區域（使用者目前座標）
    /// - Parameters:
    ///   - latitude: 緯度
    ///   - longitude: 經度
    private func setupInitialRegion(lat: Double, lon: Double) {
        let initialLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    /// 添加起點和終點標記
    /// - Parameters:
    ///   - userLat: 開始位置緯度
    ///   - userLon: 開始位置經度
    ///   - destinationLat: 到達位置緯度
    ///   - destinationLon: 到達位置經度
    private func addAnnotations(userLat: Double, userLon: Double, destinationLat: Double, destinationLon: Double) {
        let startCoordinate = CLLocationCoordinate2D(latitude: userLat,
                                                     longitude: userLon)
        
        let endCoordinate = CLLocationCoordinate2D(latitude: destinationLat,
                                                   longitude: destinationLon)

        let startAnnotation = createAnnotation(at: startCoordinate, withTitle: "起點")
        let endAnnotation = createAnnotation(at: endCoordinate, withTitle: "終點")

        mapView.addAnnotation(startAnnotation)
        mapView.addAnnotation(endAnnotation)
    }

    /// 創建標記
    private func createAnnotation(at coordinate: CLLocationCoordinate2D, withTitle title: String) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        return annotation
    }

    /// 計算和繪製路線
    private func calculateAndDrawRoute() {
        guard let startCoordinate = mapView.annotations.first?.coordinate,
              let endCoordinate = mapView.annotations.last?.coordinate else { return }

        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let endPlacemark = MKPlacemark(coordinate: endCoordinate)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: startPlacemark)
        directionRequest.destination = MKMapItem(placemark: endPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)

        directions.calculate { response, error in
            guard let response = response, error == nil else {
                print("Error calculating directions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let route = response.routes.first {
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                let routeRect = route.polyline.boundingMapRect
                self.mapView.setVisibleMapRect(routeRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
            }
        }
    }

    private func setupUI() {
        self.selectionStyle = .none
        
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

// MARK: - MKMapViewDelegate

extension MapCell: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer
    }

}
