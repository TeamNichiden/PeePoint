//
//  MainMapView.swift
//  PeePoint
//
//  Created by Hlwan Aung Phyo on 8/24/24.
//
import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var showDetailView:Bool = false
    @Published var showNearbyToiletSheet: Bool = true
    @Published var searchText: String = ""
    @Published var selectedToilet:PublicToilet? = nil
}


struct MainMapView: View {
    
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
        ZStack {
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
                .cornerRadius(20)
                .padding()
                //検索欄
                if isTap {
                    LazyVStack(alignment: .leading,spacing: 0) {
                        ForEach(listFiltered.indices, id: \.self) { index in
                            Text(listFiltered[index])
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .overlay(
                                    Rectangle()
                                        .frame(height:1)
                                        .foregroundColor(.gray)
                                        .padding(.top,34)
                                        .padding(.horizontal)
                                )
                        }
                    }
                    
                }
                
                Spacer()
                ShowNearbyListButtonView
                
            }
            
            
            
        }
        .sheet(isPresented: $viewModel.showNearbyToiletSheet) {
            defaultSheetView(
                showNearbyToiletSheet: $viewModel.showNearbyToiletSheet, selectedToilet: $viewModel.selectedToilet,
                showDetailView: $viewModel.showDetailView)
            .presentationDetents([.fraction(0.65)])
        }
        
        .sheet(isPresented: $viewModel.showDetailView) {
            if let selectedToilet = viewModel.selectedToilet {
                DetailView(selectedToilet: selectedToilet) // Use the correct label
                    .presentationDetents([.fraction(0.75)])
            }
        }
        .onAppear {
            quadtree.findNearestToilets(currentLocation: currentLocation, maxResults: 4)
        }
    }
}


extension MainMapView{
    private var ShowNearbyListButtonView:some View{
        VStack{
            Spacer()
            Button {
                viewModel.showNearbyToiletSheet = true
            } label: {
                HStack {
                    Image(systemName: "line.3.horizontal")
                        .font(.title)
                        .padding(.leading)
                    Text("お近くのトイレ")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 65)
            }
            .background(Color.white)
            .foregroundColor(.black)
            
            
        }
    }
}
#Preview {
    MainMapView()
        .environmentObject(PublicToiletManager())
    
}
