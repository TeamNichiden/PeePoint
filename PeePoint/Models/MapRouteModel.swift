//
//  MapRouteModel.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

import Foundation
import MapKit

class LocationModel: ObservableObject {
    public static let shared = LocationModel()

    private var locationManager = CLLocationManager()
    @Published var route: MKRoute?
    @Published var isFetchingRoute = false
    @Published var currentLocation: CLLocation?
    private var timer: Timer?

    @Published var isArrived = false
    
    init() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func startFetchingRoute(to destination: CLLocationCoordinate2D) {
        stopFetchingRoute() // 既存のタイマーを停止
        fetchRoute(destination: destination) // 初回のルート取得

        isFetchingRoute = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.fetchRoute(destination: destination)
            self?.checkArriaval(destination: destination)
        }
    }
    

    private func checkArriaval(destination: CLLocationCoordinate2D) {

        guard let currentLocation = locationManager.location else {
            print("Failed to get current location.")
            return
        }
        
        let currentCoordinate = currentLocation.coordinate
        let destinationCoordinate = destination
        
        let currentCLLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        let destinationCLLocation = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        
        let distance = currentCLLocation.distance(from: destinationCLLocation)
        if distance < 10 {
            isArrived = true
        }
    }


    private func stopFetchingRoute() {

        timer?.invalidate()
        timer = nil
        route = nil
        isFetchingRoute = false
    }


    private func fetchRoute(destination: CLLocationCoordinate2D) {

        guard let currentLocation = locationManager.location else {
            print("Failed to get current location.")
            return
        }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.requestsAlternateRoutes = false
        request.transportType = .walking

        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            DispatchQueue.main.async {
                self.route = response?.routes.first
            }
        }
    }
    
    private func updatecurrentLocation() {
        locationManager.requestLocation()
    }
}
