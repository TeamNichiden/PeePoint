//
//  DataModel.swift
//  PeePoint
//
//  Created by Hlwan Aung Phyo on 8/24/24.
//

import Foundation

struct PublicToilet: Codable {
    let prefectureCode: Int            // 都道府県コード又は市区町村コード
    let number: Int                    // NO
    let prefectureName: String         // 都道府県名
    let cityName: String               // 市区町村名
    let name: String                   // 名称
    let nameKana: String               // 名称_カナ
    let nameEnglish: String            // 名称_英語
    let address: String                // 住所
    let direction: String?             // 方書
    let installationLocation: String   // 設置位置
    let latitude: Double               // 緯度
    let longitude: Double              // 経度
    let totalMaleToilets: Int          // 男性トイレ総数
    let maleUrinals: Int               // 男性トイレ数（小便器）
    let maleJapaneseStyle: Int         // 男性トイレ数（和式）
    let maleWesternStyle: Int          // 男性トイレ数（洋式）
    let totalFemaleToilets: Int        // 女性トイレ総数
    let femaleJapaneseStyle: Int       // 女性トイレ数（和式）
    let femaleWesternStyle: Int        // 女性トイレ数（洋式）
    let totalUnisexToilets: Int        // 男女共用トイレ総数
    let unisexJapaneseStyle: Int       // 男女共用トイレ数（和式）
    let unisexWesternStyle: Int        // 男女共用トイレ数（洋式）
    let multifunctionalToilets: Int    // 多機能トイレ数
    let wheelchairAccessible: String   // 車椅子使用者用トイレ有無
    let infantFacilities: String       // 乳幼児用設備設置トイレ有無
    let ostomateFacilities: String     // オストメイト設置トイレ有無
    let openingTime: String            // 利用開始時間
    let closingTime: String            // 利用終了時間
    let specialUsageNotes: String?     // 利用可能時間特記事項
    let image: String?                 // 画像
    let imageLicense: String?          // 画像_ライセンス
    let remarks: String?               // 備考
}


let csvLine = "131083,1,東京都,江東区,江東区立万年橋際公衆便所,コウトウクリツマンエンバシギワコウシュウベンジョ,Public_toilet_at_Mannen-Bridge_KotoCity,江東区清澄2-14-9,,万年橋南東詰め,35.68322,139.794785,2,2,0,0,0,0,0,0,0,0,1,有,無,有,0:00,23:59,,,,"

let components = csvLine.components(separatedBy: ",")

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

