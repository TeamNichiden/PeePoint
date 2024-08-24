//
//  SerchToiletModel.swift
//  PeePoint
//
//  Created by 吉田怜央 on 2024/08/24.
//

import SwiftUI
import CoreLocation

class ToieltSerchByNameModel : NSObject,ObservableObject,CLLocationManagerDelegate {
    private var currentLocation = CLLocation(latitude: 139.6917, longitude: 35.6895)// 東京駅付近
    override init() {
        super .init()
        requestLocation()
    }

    func toiletSerch(publicToilet:PublicToilet,boundary: CGRect)-> [PublicToilet] {
        let quadtree = QuadtreeNode(boundary: boundary, capacity: 50)
        quadtree.insert(toilet: publicToilet)

    }

    private func requestLocation(){
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
        guard let currentLocation = locationManager.location else {
            return
        }
    }
}
