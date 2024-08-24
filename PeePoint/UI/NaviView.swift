//
//  NaviView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/24.
//

import SwiftUI

struct NaviView: View {
    
    //
    @State private var distance:Int = 10
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    //目的地名
                    Text("公園")
                        .font(.title)
                    //距離
                    Text("\(distance)km")
                        .opacity(0.5)
                }
                Spacer()
                //目的地変更
                Button(action: {
                    //処理
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size:40))
                        .foregroundColor(.black)
                }
                //終了ボタン
                Button(action: {
                    //終了
                }) {
                    Text("終了")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical,10)
                        .background(.red)
                        .cornerRadius(25)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NaviView()
}
