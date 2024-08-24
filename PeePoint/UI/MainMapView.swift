//
//  MainMapView.swift
//  PeePoint
//
//  Created by Hlwan Aung Phyo on 8/24/24.
//

import MapKit


class MapViewModel: ObservableObject{
    @Published var showSheet : Bool = true
    @Published var searchText : String = ""
}

import SwiftUI

struct MainMapView: View {
    var viewMNumber : Int = 0
    @EnvironmentObject private var dataModel: PublicToiletManager
    @StateObject private var viewModel = MapViewModel()
    var body: some View {
        ZStack{
            Map()
                .ignoresSafeArea()
            VStack{
                TextField("検索。。。", text: $viewModel.searchText)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height:55)
                    .background(.white)
                    .cornerRadius(30)
                    .padding()

                Spacer()
                
            }
            .sheet(isPresented: $viewModel.showSheet) {
                switch viewMNumber{
                case 0:
                    ContentView()
                        .presentationDetents([.medium])
                case 1:
                    ContentView()
                        
                default:
                    ContentView()
                }

            }
        }
    }
}

#Preview {
    MainMapView()
        .environmentObject(PublicToiletManager())
}
