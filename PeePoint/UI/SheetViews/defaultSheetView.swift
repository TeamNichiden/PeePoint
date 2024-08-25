//
//  defaultSheetView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/24.
//

import SwiftUI

struct defaultSheetView: View {
    @Binding var showNearbyToiletSheet : Bool
    @Binding var selectedToilet: PublicToilet?
    @Binding var showDetailView:Bool
    let nearestToilets:[PublicToilet]

    var body: some View {
        VStack(alignment: .leading) {
            Text("お近くのトイレ")
                .font(.title)
                .padding(.vertical)
            
            
            ForEach(nearestToilets, id: \.self) { toilet in
                HStack {
                    Group{
                        Image("toilet-thumbnil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50)
                            .cornerRadius(5)
                        
                        VStack(alignment: .leading) {
                            Text(toilet.address ?? "名前なし")
                                .font(.headline)
                                .frame(width: 150,alignment: .leading)
                            Text("徒歩 : 15分")
                                .font(.system(size:13))
                        }
                    }
                    .onTapGesture {
                        selectedToilet = toilet
                        showNearbyToiletSheet = false
                        showDetailView = true
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
                            .shadow(radius:10, y:5)
                    }
                }
                .padding()
                .background(Color(hue: 1.0, saturation: 0.002, brightness: 0.863))
                .cornerRadius(15)
                
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

//#Preview{
//    @Previewable @State var sheetIndex: Int = 0
//    NavigationStack{
//        defaultSheetView(showNearbyToiletSheet: .constant(true), selectedToilet: , showDetailView: .constant(false))
//            .environmentObject(PublicToiletManager())
//    }
//}
