//
//  MapRouteModel.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

import Foundation
import MapKit

class MapRouteModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    public static let shared = MapRouteModel()
    private var locationManager = CLLocationManager()
    @Published var route: MKRoute?
    @Published var isFetchingRoute = false
    @Published var currentLocation: CLLocation? // 現在地を保持するプロパティ
    private var timer: Timer?
    private var destination: CLLocationCoordinate2D?
    @Published var isArrived = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func startNavigation(toilet: PublicToilet) {
        let destination = CLLocationCoordinate2D(latitude: toilet.latitude, longitude: toilet.longitude)
        startFetchingRoute(destination: destination)
    }
    
    private func startFetchingRoute(destination: CLLocationCoordinate2D) {
        stopFetchingRoute() // 既存のタイマーを停止
        fetchRoute(destination: destination) // 初回のルート取得
        print("ルート取得開始")
        isFetchingRoute = true
        
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//            self?.fetchRoute(destination: destination)
//            self?.checkArrival(destination: destination)
//        }
    }
    
    private func checkArrival(destination: CLLocationCoordinate2D) {
        guard let currentLocation = currentLocation else {
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
        guard let currentLocation = currentLocation else {
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
            do {
                let response = try await directions.calculate()
                DispatchQueue.main.async {
                    self.route = response.routes.first
                }
            } catch {
                print("Failed to calculate route: \(error)")
            }
        }
    }
    
    func calculateTravelTime() -> TimeInterval {
        guard let route = route else {
            return 0
        }
        return route.expectedTravelTime
    }
    
    func calculateDistance() -> CLLocationDistance {
        guard let route = route else {
            return 0
        }
        return route.distance
    }

    // CLLocationManagerDelegateメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = newLocation
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update location: \(error)")
    }
}
