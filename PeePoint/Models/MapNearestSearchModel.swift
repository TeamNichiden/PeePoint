//
//  MapNearestSearchModel.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

import CoreGraphics
import Foundation

// トイレの構造体
struct Toilet {
    let id: Int
    let name: String
    let coordinate: (latitude: Double, longitude: Double)
}

// Quadtreeのノード
class QuadtreeNode {
    let boundary: CGRect
    let capacity: Int
    var toilets: [Toilet]
    var divided: Bool = false
    
    var northeast: QuadtreeNode?
    var northwest: QuadtreeNode?
    var southeast: QuadtreeNode?
    var southwest: QuadtreeNode?
    
    init(boundary: CGRect, capacity: Int) {
        self.boundary = boundary
        self.capacity = capacity
        self.toilets = []
    }
    
    // 座標を挿入する
    func insert(toilet: Toilet) -> Bool {
        let point = CGPoint(x: toilet.coordinate.longitude, y: toilet.coordinate.latitude)
        
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
            return (northeast!.insert(toilet: toilet) ||
                    northwest!.insert(toilet: toilet) ||
                    southeast!.insert(toilet: toilet) ||
                    southwest!.insert(toilet: toilet))
        }
    }
    
    // クワッドを分割する
    func subdivide() {
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
    
    // 複数の最寄りトイレを探す
    func queryNearest(point: CGPoint, maxResults: Int) -> [Toilet] {
        var closestToilets: [Toilet] = []
        var distances: [(Toilet, CGFloat)] = []
        
        for toilet in toilets {
            let toiletPoint = CGPoint(x: toilet.coordinate.longitude, y: toilet.coordinate.latitude)
            let distance = hypot(toiletPoint.x - point.x, toiletPoint.y - point.y)
            distances.append((toilet, distance))
        }
        
        if divided {
            let nodes = [northeast, northwest, southeast, southwest]
            for node in nodes {
                if node!.boundary.contains(point) {
                    let nearestInChild = node!.queryNearest(point: point, maxResults: maxResults)
                    for toilet in nearestInChild {
                        let toiletPoint = CGPoint(x: toilet.coordinate.longitude, y: toilet.coordinate.latitude)
                        let distance = hypot(toiletPoint.x - point.x, toiletPoint.y - point.y)
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

/*
 // テスト用のコード
 let boundary = CGRect(x: -180, y: -90, width: 360, height: 180) // 地球全体をカバーする長方形
 let quadtree = QuadtreeNode(boundary: boundary, capacity: 4)
 
 // いくつかのトイレを挿入
 let toilets = [
 Toilet(id: 1, name: "Toilet A", coordinate: (latitude: 35.6586, longitude: 139.7454)), // 東京タワー
 Toilet(id: 2, name: "Toilet B", coordinate: (latitude: 34.6937, longitude: 135.5023)), // 大阪
 Toilet(id: 3, name: "Toilet C", coordinate: (latitude: 35.0116, longitude: 135.7681)), // 京都
 Toilet(id: 4, name: "Toilet D", coordinate: (latitude: 43.0687, longitude: 141.3508)), // 札幌
 Toilet(id: 5, name: "Toilet E", coordinate: (latitude: 26.2124, longitude: 127.6809)), // 沖縄
 ]
 
 for toilet in toilets {
 quadtree.insert(toilet: toilet)
 }
 
 // 現在地に最も近い4つのトイレを探す
 let currentLocation = CGPoint(x: 139.6917, y: 35.6895) // 東京駅付近
 let nearestToilets = quadtree.queryNearest(point: currentLocation, maxResults: 4)
 
 for toilet in nearestToilets {
 print("Toilet: \(toilet.name) at \(toilet.coordinate)")
 }
 // テスト用のコード
 
 
 /*
  
  •    座標系の変換: coordinateは緯度・経度（latitude, longitude）で表現。これをCGPointに変換して使用。
  •    QuadtreeNode: 地球全体をカバーするCGRectを使用し、地理座標を管理。
  •    insert(toilet:): トイレの位置情報をQuadtreeに挿入。
  •    queryNearest(point:): 緯度・経度に基づいて現在地に最も近いトイレを検索。
  
  */
 
 */
