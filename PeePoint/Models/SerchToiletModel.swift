//
//  SerchToiletModel.swift
//  PeePoint
//
//  Created by 吉田怜央 on 2024/08/24.
//

import SwiftUI
import CoreLocation

class SerchToiletModel : NSObject,ObservableObject,CLLocationManagerDelegate {
    @Published var currentLocation = CLLocation(latitude: 139.6917, longitude: 35.6895)// 東京駅付近
    private var quadtree = PublicToiletManager()

    override init() {
        super .init()
        requestLocation()
    }

    func toiletSerch() {
        quadtree.findNearestToilets(currentLocation: currentLocation, maxResults: 20)
    }

    private func requestLocation(){
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
        guard let _currentLocation = locationManager.location else {
            return
        }
        self.currentLocation = _currentLocation
    }
}

