//
//  defaultSheetView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/24.
//

import SwiftUI

struct defaultSheetView: View {
    let nearestToilets:[PublicToilet]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("お近くのトイレ")
                .font(.title)
                .padding(.bottom)
            ForEach(nearestToilets, id: \.self) { toilet in
                HStack {
                    Image(systemName: "photo.artframe")
                        .frame(width: 30)
                    VStack(alignment: .leading) {
                        Text("\(toilet.name!)")
                            .font(.system(size:13))
                        Text("徒歩 : 15分")
                            .font(.system(size:13))
                    }
                    Spacer()
                    //案内スタート
                    Button(action: {
                        //
                    }) {
                        Text("Direction")
                            .font(.system(size:17))
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(.vertical,10)
                            .padding(.horizontal,30)
                            .background(Color.customColor)
                            .cornerRadius(30)
                            .shadow(color: .black, radius: 2)
                    }
                }
                .padding()
                .background(Color(hue: 1.0, saturation: 0.002, brightness: 0.963))
                .cornerRadius(30)
            }
        }.frame(width: UIScreen.main.bounds.width-50)
    }
}

extension Color {
    static var customColor:Color {
        return Color(red: 0.4,green: 0.3, blue: 0.8)
    }
}

