//
//  DetailView.swift
//  PeePoint
//
//  Created by Hlwan Aung Phyo on 8/24/24.
//

import SwiftUI

struct DetailView: View {

    @EnvironmentObject private var dataModel:PublicToiletManager
    var body: some View {
        VStack{
            HStack{
                Text(dataModel.toilets[0].name ?? "No name")
                    .font(.title)
                    .frame(width:350)
                Spacer()
                Image(systemName: "heart")
                    .font(.system(size: 25))
                    .padding(.trailing)
            }
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    ForEach(1...3,id: \.self){_ in
                        
                        Image(systemName: "play.square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:200)
                    }
                    
                }
                
                
            }
        }

    }
}

#Preview {
    DetailView()
        .environmentObject(PublicToiletManager())

