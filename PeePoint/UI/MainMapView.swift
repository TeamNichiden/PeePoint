//
//  MainMapView.swift
//  PeePoint
//
//  Created by Hlwan Aung Phyo on 8/24/24.
//
import SwiftUI
import MapKit



class MapViewModel: ObservableObject {
    @Published var showDetailView: Bool = false
    @Published var showNearbyToiletSheet: Bool = true
    @Published var searchText: String = ""
    @Published var selectedToilet: PublicToilet? = nil
    
    // Filter
    @Published var filterByWheelchairAccessible: Bool = false
    @Published var filterByInfantFacilities: Bool = false
    @Published var filterByOstomateFacilities: Bool = false
    @Published var filterByunisexJapaneseStyle:Bool = false
    @Published var filterByunisexWesternStyle:Bool = false
    @Published var filterBymultifunctionalToilets:Bool = false
}
struct MainMapView: View {
    @EnvironmentObject private var dataModel: PublicToiletManager
    @StateObject private var viewModel = MapViewModel()
    @State var showSearchView: Bool = false
    
    var body: some View {
        ZStack {
            Map()
                .ignoresSafeArea()
            VStack {
                searchBar
                
                // Filter Buttons
                ScrollView(.horizontal,showsIndicators: false){
                    HStack {
                        Button(action: {
                            viewModel.filterByWheelchairAccessible.toggle()
                        }) {
                            Text("車椅子対応")
                                .padding(.horizontal)
                                .frame(height: 26)
                                .foregroundColor(viewModel.filterByWheelchairAccessible ? .white : .black)
                                .background(viewModel.filterByWheelchairAccessible ? Color.blue : Color.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            viewModel.filterByInfantFacilities.toggle()
                        }) {
                            Text("乳幼児用設備")
                                .padding(.horizontal)
                                .frame(height: 26)
                                .foregroundColor(viewModel.filterByInfantFacilities ? .white : .black)
                                .background(viewModel.filterByInfantFacilities ? Color.blue : Color.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            viewModel.filterByunisexJapaneseStyle.toggle()
                        }) {
                            Text("和式")
                                .padding(.horizontal)
                                .frame(height: 26)
                                .foregroundColor(viewModel.filterByunisexJapaneseStyle ? .white : .black)
                                .background(viewModel.filterByunisexJapaneseStyle ? Color.blue : Color.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            viewModel.filterByOstomateFacilities.toggle()
                        }) {
                            Text("オストメイト対応")
                                .padding(.horizontal)
                                .frame(height: 26)
                                .foregroundColor(viewModel.filterByOstomateFacilities ? .white : .black)
                                .background(viewModel.filterByOstomateFacilities ? Color.blue : Color.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            viewModel.filterByunisexWesternStyle.toggle()
                        }) {
                            Text("洋式")
                                .padding(.horizontal)
                                .frame(height: 26)
                                .foregroundColor(viewModel.filterByunisexWesternStyle ? .white : .black)
                                .background(viewModel.filterByunisexWesternStyle ? Color.blue : Color.white)
                                .cornerRadius(10)
                        }
                        Button(action: {
                            viewModel.filterBymultifunctionalToilets.toggle()
                        }) {
                            Text("多機能")
                                .padding(.horizontal)
                                .frame(height: 26)
                                .foregroundColor(viewModel.filterBymultifunctionalToilets ? .white : .black)
                                .background(viewModel.filterBymultifunctionalToilets ? Color.blue : Color.white)
                                .cornerRadius(10)
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                ShowNearbyListButtonView
            }
    }
        .navigationBarHidden(true)
    
        .sheet(isPresented: $viewModel.showNearbyToiletSheet) {
            defaultSheetView(
                showNearbyToiletSheet: $viewModel.showNearbyToiletSheet,
                selectedToilet: $viewModel.selectedToilet,
                showDetailView: $viewModel.showDetailView
            )
            .presentationDetents([.fraction(0.58)])
        }
        .sheet(isPresented: $viewModel.showDetailView) {
            if let selectedToilet = viewModel.selectedToilet {
                DetailView(selectedToilet: selectedToilet)
                    .presentationDetents([.fraction(0.75)])
            }
        }
        .fullScreenCover(isPresented: $showSearchView, content: {
            searchListView(
                            isPresented: $showSearchView,
                            showDetailView: $viewModel.showDetailView,
                            selectedToilet: $viewModel.selectedToilet,
                            filterByWheelchairAccessible: $viewModel.filterByWheelchairAccessible,
                            filterByInfantFacilities: $viewModel.filterByInfantFacilities,
                            filterByOstomateFacilities: $viewModel.filterByOstomateFacilities,
                            filterByunisexJapaneseStyle: $viewModel.filterByunisexJapaneseStyle,
                            filterByunisexWesternStyle: $viewModel.filterByunisexWesternStyle,
                            filterBymultifunctionalToilets: $viewModel.filterBymultifunctionalToilets
                        )
        })
}
}


extension MainMapView {
    private var ShowNearbyListButtonView: some View {
        VStack {
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
    
    private var filteredToilets: [PublicToilet] {
        dataModel.toilets.filter { toilet in
            (!viewModel.filterByWheelchairAccessible || toilet.wheelchairAccessible == "○") &&
            (!viewModel.filterByInfantFacilities || toilet.infantFacilities == "○") &&
            (!viewModel.filterByOstomateFacilities || toilet.ostomateFacilities == "○") &&
            (!viewModel.filterByunisexJapaneseStyle || toilet.unisexJapaneseStyle ?? 0 > 0) &&
            (!viewModel.filterByunisexWesternStyle || toilet.unisexWesternStyle ?? 0 > 0) &&
            (!viewModel.filterBymultifunctionalToilets || toilet.multifunctionalToilets ?? 0 > 0)
        }
    }
    private var searchBar: some View{
        Button {
            showSearchView = true
        } label: {
            Text("検索")
                .padding(.leading)
                .font(.headline)
                .foregroundColor(.gray)
                .font(.headline)
                .frame(maxWidth: .infinity,alignment: .leading)
                .frame(height:55)
                .background(.white)
                .cornerRadius(10)
                .padding()
                .shadow(radius:10, y:5)
        }
        
    }
}
#Preview {
    MainMapView()
        .environmentObject(PublicToiletManager())
    
}
