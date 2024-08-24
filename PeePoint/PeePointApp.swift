//
//  PeePointApp.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

import SwiftUI

@main
struct PeePointApp: App {
    var body: some Scene {
        WindowGroup {
            DetailView()
                .environmentObject(PublicToiletManager())
                                   
        }
    }
}
