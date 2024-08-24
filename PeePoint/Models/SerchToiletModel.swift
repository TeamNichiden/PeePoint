//
//  SerchToiletModel.swift
//  PeePoint
//
//  Created by 吉田怜央 on 2024/08/24.
//

import SwiftUI
import CoreLocation

class ToieltSerchByNameModel : NSObject,ObservableObject,CLLocationManagerDelegate {
    func toiletSerch(publicToilet:PublicToilet,boundary: CGRect)-> [PublicToilet] {
        let quadtree = QuadtreeNode(boundary: boundary, capacity: 50)
        quadtree.insert(toilet: publicToilet)

    }

    private func requestLocation()-> CLLocationManager{
        let locationManager = CLLocationManager()

        init(){
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
        return locationManager
    }
}
