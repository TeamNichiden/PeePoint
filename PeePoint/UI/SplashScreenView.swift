//
//  SplashScreenView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/25.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var iconOpacity:Double = 1.0
    @State private var showMainView:Bool = false
    
    var body: some View {
        VStack {
            Image("iconimg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
                .opacity(iconOpacity)
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    iconOpacity -= 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showMainView = true
            }
        }
        .fullScreenCover(isPresented: $showMainView) {
            MainMapView()
        }
    }
}

#Preview {
    SplashScreenView()
}
