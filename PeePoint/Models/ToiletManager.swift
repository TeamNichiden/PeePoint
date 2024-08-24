//
//  FavoriteToiletModel.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

import Foundation
import SwiftData

class PublicToiletManager: ObservableObject {
    @Published var toilets: [PublicToilet] = []
    private let favoritesKey = "favoriteToilets"

        @Published var favoriteToilets: [Int] = [] {
            didSet {
                saveFavorites()
            }
        }
    
    init(filePath: String) {
        // ファイルパスを取得
        if let path = Bundle.main.path(forResource: filePath, ofType: nil) {
            loadCSV(filePath: path)
            loadFavorites()
        } else {
            print("CSVファイル見つからない: \(filePath)")
        }
    }
    
    func loadCSV(filePath: String) {
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = fileContents.components(separatedBy: .newlines)
            let dataLines = lines.dropFirst()
            
            for line in dataLines {
                guard !line.isEmpty else { continue }
                let components = line.components(separatedBy: ",")
                let toilet = PublicToilet(
                    prefectureCode: Int(components[0]) ?? 0,
                    number: Int(components[1]) ?? 0,
                    prefectureName: components[2],
                    cityName: components[3],
                    name: components[4],
                    nameKana: components[5],
                    nameEnglish: components[6],
                    address: components[7],
                    direction: components[8].isEmpty ? nil : components[8],
                    installationLocation: components[9],
                    latitude: Double(components[10]) ?? 0.0,
                    longitude: Double(components[11]) ?? 0.0,
                    totalMaleToilets: Int(components[12]) ?? 0,
                    maleUrinals: Int(components[13]) ?? 0,
                    maleJapaneseStyle: Int(components[14]) ?? 0,
                    maleWesternStyle: Int(components[15]) ?? 0,
                    totalFemaleToilets: Int(components[16]) ?? 0,
                    femaleJapaneseStyle: Int(components[17]) ?? 0,
                    femaleWesternStyle: Int(components[18]) ?? 0,
                    totalUnisexToilets: Int(components[19]) ?? 0,
                    unisexJapaneseStyle: Int(components[20]) ?? 0,
                    unisexWesternStyle: Int(components[21]) ?? 0,
                    multifunctionalToilets: Int(components[22]) ?? 0,
                    wheelchairAccessible: components[23],
                    infantFacilities: components[24],
                    ostomateFacilities: components[25],
                    openingTime: components[26],
                    closingTime: components[27],
                    specialUsageNotes: components[28].isEmpty ? nil : components[28],
                    image: components[29].isEmpty ? nil : components[29],
                    imageLicense: components[30].isEmpty ? nil : components[30],
                    remarks: components[31].isEmpty ? nil : components[31]
                )
                toilets.append(toilet)
            }
            print("トイレ情報が \(toilets.count) 件読み込まれました。")
        } catch {
            print("ファイルの読み込みに失敗しました: \(error)")
        }
    }
    
    // お気に入りにトイレを追加
        func addFavorite(toilet: PublicToilet) {
            if !favoriteToilets.contains(toilet.number) {
                favoriteToilets.append(toilet.number)
            }
        }

        // お気に入りからトイレを削除
        func removeFavorite(toilet: PublicToilet) {
            favoriteToilets.removeAll { $0 == toilet.number }
        }

        // トイレが既にお気に入りに入っているか確認
        func isFavorite(toilet: PublicToilet) -> Bool {
            return favoriteToilets.contains(toilet.number)
        }

        // UserDefaultsにお気に入りを保存
        private func saveFavorites() {
            UserDefaults.standard.set(favoriteToilets, forKey: favoritesKey)
        }

        // UserDefaultsからお気に入りを読み込む
        private func loadFavorites() {
            if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
                favoriteToilets = savedFavorites
            }
        }
}
