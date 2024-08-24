//
//  FavoriteToiletModel.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

import Foundation
import SwiftData

// PublicToilet構造体は既に定義済みと仮定
class PublicToiletManager: ObservableObject {
    @Published var toilets: [PublicToilet] = []
    let filePaths = ["utf8.csv","dataSet2.csv"]
    
    init() {
        for filePath in filePaths {
            if let path = Bundle.main.path(forResource: filePath, ofType: nil) {
                loadCSV(filePath: path)
            } else {
                print("CSVファイル見つからない: \(filePath)")
            }
        }
        print("統一後のトイレ情報が \(toilets.count) 件になりました。")
    }
    
    func loadCSV(filePath: String) {
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = fileContents.components(separatedBy: .newlines)
            let dataLines = lines.dropFirst()
            
            for line in dataLines {
                guard !line.isEmpty else { continue }
                let components = line.components(separatedBy: ",")
                
                // UTF-8 ファイルの構造に合わせてデータを解析
                if components.count == 32 {
                    let toilet = PublicToilet(
                        prefectureCode: Int(components[0]),
                        number: Int(components[1]),
                        prefectureName: components[2],
                        cityName: components[3],
                        name: components[4],
                        nameKana: components[5],
                        nameEnglish: components[6],
                        address: components[7],
                        direction: components[8].isEmpty ? nil : components[8],
                        installationLocation: components[9],
                        latitude: Double(components[10]),
                        longitude: Double(components[11]),
                        totalMaleToilets: Int(components[12]),
                        maleUrinals: Int(components[13]),
                        maleJapaneseStyle: Int(components[14]),
                        maleWesternStyle: Int(components[15]),
                        totalFemaleToilets: Int(components[16]),
                        femaleJapaneseStyle: Int(components[17]),
                        femaleWesternStyle: Int(components[18]),
                        totalUnisexToilets: Int(components[19]),
                        unisexJapaneseStyle: Int(components[20]),
                        unisexWesternStyle: Int(components[21]),
                        multifunctionalToilets: Int(components[22]),
                        wheelchairAccessible: components[23],
                        infantFacilities: components[24],
                        ostomateFacilities: components[25],
                        openingTime: components[26],
                        closingTime: components[27],
                        specialUsageNotes: components[28].isEmpty ? nil : components[28],
                        image: [components[29].isEmpty ? nil : components[29]],
                        imageLicense: components[30].isEmpty ? nil : components[30],
                        remarks: components[31].isEmpty ? nil : components[31]
                    )
                    toilets.append(toilet)
                    
                    // dataSet2 の構造に合わせてデータを解析
                } else if components.count == 44 {
                    
                    let toilet = PublicToilet(
                        prefectureCode: nil, // dataSet2には都道府県コードがない
                        number: nil, // dataSet2にはNOがない
                        prefectureName: components[6],
                        cityName: components[7],
                        name: components[9],
                        nameKana: nil, // dataSet2には名称_カナがない
                        nameEnglish: nil, // dataSet2には名称_英語がない
                        address: components[7],
                        direction: nil, // dataSet2には方書がない
                        installationLocation: components[9],
                        latitude: Double(components[13]),
                        longitude: Double(components[12]),
                        totalMaleToilets: nil, // dataSet2には男性トイレ総数がない
                        maleUrinals: nil, // dataSet2には男性トイレ数がない
                        maleJapaneseStyle: nil, // dataSet2には男性トイレ数（和式）がない
                        maleWesternStyle: nil, // dataSet2には男性トイレ数（洋式）がない
                        totalFemaleToilets: nil, // dataSet2には女性トイレ総数がない
                        femaleJapaneseStyle: nil, // dataSet2には女性トイレ数（和式）がない
                        femaleWesternStyle: nil, // dataSet2には女性トイレ数（洋式）がない
                        totalUnisexToilets: nil, // dataSet2には男女共用トイレ総数がない
                        unisexJapaneseStyle: nil, // dataSet2には男女共用トイレ数（和式）がない
                        unisexWesternStyle: nil, // dataSet2には男女共用トイレ数（洋式）がない
                        multifunctionalToilets: nil, // dataSet2には多機能トイレ数がない
                        wheelchairAccessible: components[18], // dataSet2には車椅子使用者用トイレ有無がない
                        infantFacilities: components[25], // dataSet2には乳幼児用設備設置トイレ有無がない
                        ostomateFacilities: components[22],
                        openingTime: nil, // dataSet2には利用開始時間がない
                        closingTime: nil, // dataSet2には利用終了時間がない
                        specialUsageNotes: components[36].isEmpty ? nil : components[36],
                        image: [components[37].isEmpty ? nil : components[37],
                                components[38].isEmpty ? nil : components[38],
                                components[39].isEmpty ? nil : components[39]],
                        imageLicense: nil, // dataSet2には画像ライセンスがない
                        remarks: components[37].isEmpty ? nil : components[37]
                    )
                    toilets.append(toilet)
                }
            }
            print("ファイル \(filePath) から \(toilets.count) 件のトイレ情報が読み込まれました。")
        } catch {
            print("ファイルの読み込みに失敗しました: \(error)")
        }
    }
}

/*
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
 */
