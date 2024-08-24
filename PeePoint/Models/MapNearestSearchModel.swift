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

