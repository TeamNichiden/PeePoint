//
//  MapNearestSearchModel.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

import CoreGraphics
import Foundation

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
    
    // 座標を挿入する

    func insert(toilet: PublicToilet) -> Bool {
        let point = CGPoint(x: toilet.longitude!, y: toilet.latitude!)

        
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
    
    // 複数の最寄りトイレを探す

    func queryNearest(point: CGPoint, maxResults: Int) -> [PublicToilet] {
        var closestToilets: [PublicToilet] = []
        var distances: [(PublicToilet, CGFloat)] = []
        
        for toilet in toilets {
            let toiletPoint = CGPoint(x: toilet.longitude!, y: toilet.latitude!)

          
            let distance = hypot(toiletPoint.x - point.x, toiletPoint.y - point.y)
            distances.append((toilet, distance))
        }
        
        if divided {
            let nodes = [northeast, northwest, southeast, southwest]
            for node in nodes {
                if node!.boundary.contains(point) {
                    let nearestInChild = node!.queryNearest(point: point, maxResults: maxResults)
                    for toilet in nearestInChild {

                        let toiletPoint = CGPoint(x: toilet.longitude!, y: toilet.latitude!)

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

 // CSVのデータからトイレ情報を作成して挿入
 let csvLine = "131083,1,東京都,江東区,江東区立万年橋際公衆便所,コウトウクリツマンエンバシギワコウシュウベンジョ,Public_toilet_at_Mannen-Bridge_KotoCity,江東区清澄2-14-9,,万年橋南東詰め,35.68322,139.794785,2,2,0,0,0,0,0,0,0,0,1,有,無,有,0:00,23:59,,,,"
 let components = csvLine.components(separatedBy: ",")
 
 let publicToilet = PublicToilet(
 prefectureCode: Int(components[0])!,
 number: Int(components[1])!,
 prefectureName: components[2],
 cityName: components[3],
 name: components[4],
 nameKana: components[5],
 nameEnglish: components[6],
 address: components[7],
 direction: components[8],
 installationLocation: components[9],
 latitude: Double(components[10])!,
 longitude: Double(components[11])!,
 totalMaleToilets: Int(components[12])!,
 maleUrinals: Int(components[13])!,
 maleJapaneseStyle: Int(components[14])!,
 maleWesternStyle: Int(components[15])!,
 totalFemaleToilets: Int(components[16])!,
 femaleJapaneseStyle: Int(components[17])!,
 femaleWesternStyle: Int(components[18])!,
 totalUnisexToilets: Int(components[19])!,
 unisexJapaneseStyle: Int(components[20])!,
 unisexWesternStyle: Int(components[21])!,
 multifunctionalToilets: Int(components[22])!,
 wheelchairAccessible: components[23],
 infantFacilities: components[24],
 ostomateFacilities: components[25],
 openingTime: components[26],
 closingTime: components[27],
 specialUsageNotes: components[28],
 image: components[29],
 imageLicense: components[30],
 remarks: components[31]
 )
 
 quadtree.insert(toilet: publicToilet)

 
 // 現在地に最も近い4つのトイレを探す
 let currentLocation = CGPoint(x: 139.6917, y: 35.6895) // 東京駅付近
 let nearestToilets = quadtree.queryNearest(point: currentLocation, maxResults: 4)
 
 for toilet in nearestToilets {

 print("Toilet: \(toilet.name) at \(toilet.latitude), \(toilet.longitude)")
 }

 */
