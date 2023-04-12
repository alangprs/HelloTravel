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
        setupMapView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMapView() {
        // 設置地圖縮放級別和區域
        let initialLocation = CLLocationCoordinate2D(latitude: 25.0192, longitude: 121.4662)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        
        // 根據需要標記起點和終點
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = CLLocationCoordinate2D(latitude: 25.0192, longitude: 121.4662)
        startAnnotation.title = "起點"
        mapView.addAnnotation(startAnnotation)

        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = CLLocationCoordinate2D(latitude: 25.0418, longitude: 121.5654)
        endAnnotation.title = "終點"
        mapView.addAnnotation(endAnnotation)
        
        // 使用 MKDirections 計算從起點到終點的路線
        let startPlacemark = MKPlacemark(coordinate: startAnnotation.coordinate)
        let endPlacemark = MKPlacemark(coordinate: endAnnotation.coordinate)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: startPlacemark)
        directionRequest.destination = MKMapItem(placemark: endPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)

        // 在地圖上繪製路線
        directions.calculate { response, error in
            guard let response = response, error == nil else {
                print("Error calculating directions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // 路線可能包含多個路線段，這裡我們選擇第一個路線。
            if let route = response.routes.first {
                // 在地圖上添加路線的線條圖層。
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                // 調整地圖區域以顯示整條路線。
                let routeRect = route.polyline.boundingMapRect
                self.mapView.setVisibleMapRect(routeRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
            }
        }
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

// MARK: - MKMapViewDelegate

extension MapCell: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

}
