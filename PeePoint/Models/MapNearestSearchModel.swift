//
//  MapNearestSearchModel.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

//
//  MapNearestSearchModel.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

import CoreGraphics
import Foundation
import CoreLocation

class MapNearestSearchModel: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    private var quadtree: QuadtreeNode
    
    override init() {
        self.locationManager = CLLocationManager()
        self.quadtree = QuadtreeNode(boundary: CGRect(x: -180, y: -90, width: 360, height: 180), capacity: 500)
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    // CLLocationManagerDelegateメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let nearestToilets = quadtree.queryNearest(point: location, maxResults: 200)
            
            for toilet in nearestToilets {
                print("Toilet: \(toilet.name) at \(toilet.latitude), \(toilet.longitude)")
            }
        }
    }
    
    // CLLocationManagerDelegateメソッド
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
}

// Quadtreeのノード
class QuadtreeNode {
    private let boundary: CGRect
    private let capacity: Int
    private var toilets: [PublicToilet]
    private var divided: Bool = false
    
    private var northeast: QuadtreeNode?
    private var northwest: QuadtreeNode?
    private var southeast: QuadtreeNode?
    private var southwest: QuadtreeNode?
    
    init(boundary: CGRect, capacity: Int) {
        self.boundary = boundary
        self.capacity = capacity
        self.toilets = []
    }
    
    func insert(toilet: PublicToilet) -> Bool {
        let point = CGPoint(x: toilet.longitude, y: toilet.latitude)
        print("Inserting toilet at \(point)")
        guard boundary.contains(point) else {
            return false
        }
        
        if toilets.count < capacity {
            toilets.append(toilet)
            return true
        } else {
            if !divided {
                subdivide()
            }
            return (northeast?.insert(toilet: toilet) ?? false ||
                    northwest?.insert(toilet: toilet) ?? false ||
                    southeast?.insert(toilet: toilet) ?? false ||
                    southwest?.insert(toilet: toilet) ?? false)
        }
    }
    
    private func subdivide() {
        let x = boundary.origin.x
        let y = boundary.origin.y
        let w = boundary.size.width / 2
        let h = boundary.size.height / 2
        
        let ne = CGRect(x: x + w, y: y, width: w, height: h)
        let nw = CGRect(x: x, y: y, width: w, height: h)
        let se = CGRect(x: x + w, y: y + h, width: w, height: h)
        let sw = CGRect(x: x, y: y + h, width: w, height: h)
        
        northeast = QuadtreeNode(boundary: ne, capacity: capacity)
        northwest = QuadtreeNode(boundary: nw, capacity: capacity)
        southeast = QuadtreeNode(boundary: se, capacity: capacity)
        southwest = QuadtreeNode(boundary: sw, capacity: capacity)
        
        divided = true
    }
    
    func queryNearest(point: CLLocation, maxResults: Int) -> [PublicToilet] {
        var closestToilets: [PublicToilet] = []
        var distances: [(PublicToilet, CLLocationDistance)] = []
        let currentLocation = CLLocation(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)
        
        // トイレのデータをチェック
        for toilet in toilets {
            let toiletLocation = CLLocation(latitude: toilet.latitude, longitude: toilet.longitude)
            let distance = haversineDistance(from: currentLocation.coordinate, to: toiletLocation.coordinate)
            print("Toilet Location: (\(toilet.latitude), \(toilet.longitude))")
            print("Query Point: (\(point.coordinate.latitude), \(point.coordinate.longitude))")
            print("Distance: \(distance)")
            distances.append((toilet, distance))
        }
        
        // 子ノードのクエリ
        if divided {
            let nodes = [northeast, northwest, southeast, southwest]
            for node in nodes {
                if let node = node, node.boundary.intersects(CGRect(x: point.coordinate.longitude, y: point.coordinate.latitude, width: 0, height: 0)) {
                    let nearestInChild = node.queryNearest(point: point, maxResults: maxResults)
                    for toilet in nearestInChild {
                        let toiletLocation = CLLocation(latitude: toilet.latitude, longitude: toilet.longitude)
                        let distance = haversineDistance(from: currentLocation.coordinate, to: toiletLocation.coordinate)
                        print("Child Toilet Location: (\(toilet.latitude), \(toilet.longitude))")
                        distances.append((toilet, distance))
                    }
                }
            }
        }
        
        distances.sort { $0.1 < $1.1 }
        
        for (toilet, _) in distances.prefix(maxResults) {
            closestToilets.append(toilet)
        }
        
        return closestToilets
    }
}

func haversineDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
    let radius: CLLocationDistance = 6371.0 // 地球の半径（キロメートル）
    
    let lat1 = from.latitude.toRadians()
    let lon1 = from.longitude.toRadians()
    let lat2 = to.latitude.toRadians()
    let lon2 = to.longitude.toRadians()
    
    let dLat = lat2 - lat1
    let dLon = lon2 - lon1
    
    let a = sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1) * cos(lat2) *
            sin(dLon / 2) * sin(dLon / 2)
    
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))
    
    return radius * c * 1000 // メートル単位に変換
}

extension Double {
    func toRadians() -> Double {
        return self * .pi / 180
    }
}
