//
//  defaultSheetView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/24.
//

import SwiftUI

struct defaultSheetView: View {
    @EnvironmentObject var toiletData:PublicToiletManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("お近くのトイレ")
                .font(.title)
                .padding(.bottom)
            
            ScrollView{
                ForEach(toiletData.nearestToilets, id: \.self) { toilet in
                    HStack {
                        Image("toilet-thumbnil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50)
                            .cornerRadius(5)

                        VStack(alignment: .leading) {
                            Text(toilet.address ?? "名前なし")
                                .font(.headline)
                            Text("徒歩 : 15分")
                                .font(.system(size:13))
                        }
                        Spacer()
                        //案内スタート
                        Button(action: {
                            //
                        }) {
                            Text("Direction")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame(height:48)
                                .background(Color.customColor)
                                .cornerRadius(10)
                                .padding(.leading)
                        }
                    }
                    .padding()
                    .background(Color(hue: 1.0, saturation: 0.002, brightness: 0.863))
                    .cornerRadius(15)
                }
            }
        }
        .padding()

    }
}

extension Color {
    static var customColor:Color {
        return Color(red: 0.4,green: 0.3, blue: 0.8)
    }
}

#Preview{
    defaultSheetView()
        .environmentObject(PublicToiletManager())
}
