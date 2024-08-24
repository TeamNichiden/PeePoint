//
//  DataModel.swift
//  PeePoint
//
//  Created by Hlwan Aung Phyo on 8/24/24.
//

import Foundation


struct PublicToilet: Codable,Hashable,Identifiable {
    var id = UUID()
    let prefectureCode: Int?              // 都道府県コード又は市区町村コード
    let number: Int?                      // NO
    let prefectureName: String?           // 都道府県名
    let cityName: String?                 // 市区町村名
    let name: String?                     // 名称
    let nameKana: String?                 // 名称_カナ
    let nameEnglish: String?              // 名称_英語
    let address: String?                  // 住所
    let direction: String?                // 方書
    let installationLocation: String?     // 設置位置
    let latitude: Double               // 緯度
    let longitude: Double               // 経度
    let totalMaleToilets: Int?            // 男性トイレ総数
    let maleUrinals: Int?                 // 男性トイレ数（小便器）
    let maleJapaneseStyle: Int?           // 男性トイレ数（和式）
    let maleWesternStyle: Int?            // 男性トイレ数（洋式）
    let totalFemaleToilets: Int?          // 女性トイレ総数
    let femaleJapaneseStyle: Int?         // 女性トイレ数（和式）
    let femaleWesternStyle: Int?          // 女性トイレ数（洋式）
    let totalUnisexToilets: Int?          // 男女共用トイレ総数
    let unisexJapaneseStyle: Int?         // 男女共用トイレ数（和式）
    let unisexWesternStyle: Int?          // 男女共用トイレ数（洋式）
    let multifunctionalToilets: Int?      // 多機能トイレ数
    let wheelchairAccessible: String?     // 車椅子使用者用トイレ有無
    let infantFacilities: String?         // 乳幼児用設備設置トイレ有無
    let ostomateFacilities: String?       // オストメイト設置トイレ有無
    let openingTime: String?              // 利用開始時間
    let closingTime: String?              // 利用終了時間
    let specialUsageNotes: String?        // 利用可能時間特記事項
    let image: [String?]                  // 画像
    let imageLicense: String?             // 画像_ライセンス
    let remarks: String?                  // 備考
    
}
    
    
    
   
