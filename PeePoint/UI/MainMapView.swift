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
    @StateObject private var quadtree = PublicToiletManager()
    let currentLocation = CLLocation(latitude: 139.6917, longitude: 35.6895) // 東京駅付近
    
    //Sample List
    let items = ["江東区","江東区","江東区"]
    //Sampleフィルター
    private var listFiltered: [String] {
        if viewModel.searchText.isEmpty {
            return items
        } else {
            return items.filter {
                $0.localizedStandardContains(viewModel.searchText)
            }
        }
    }
    
    @State private var isTap:Bool = false
    
    var body: some View {
        ZStack{
            Map()
                .ignoresSafeArea()
            VStack{
                TextField("検索", text: $viewModel.searchText, onEditingChanged: { item in
                    isTap = item
                })
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height:55)
                    .background(.white)
                    .cornerRadius(30)
                    .padding()
                
                //検索欄
                if isTap {
                    LazyVStack(alignment: .leading,spacing: 0) {
                        ForEach(listFiltered.indices, id: \.self) { index in
                            Text(listFiltered[index])
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .border(Color.gray)
                        }
                    }
                }
                
                Spacer()
                
            }
            .sheet(isPresented: $viewModel.showSheet) {
                switch viewMNumber{
                case 0:
                    defaultSheetView(nearestToilets:quadtree.nearestToilets)
                        .presentationDetents([.medium])
                case 1:
                    DetailView()
                      .presentationDetents([.fraction(0.65), .large])
                        
                default:
                    ContentView()
                }

            }
        }.onAppear {
            quadtree.findNearestToilets(currentLocation: currentLocation, maxResults: 4)
        }
//        .background(isTap ? Color.white : Color.clear)
    }
}

#Preview {
    MainMapView()
        .environmentObject(PublicToiletManager())
    
}
