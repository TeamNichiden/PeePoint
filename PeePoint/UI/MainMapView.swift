//
//  MainMapView.swift
//  PeePoint
//
//  Created by Hlwan Aung Phyo on 8/24/24.
//
import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var showSheet: Bool = true
    @Published var searchText: String = ""
    @Published var viewNumber: Int = 0 {
        didSet {
            sheetSize = calculateSheetSize()
        }
    }
    
    @Published var sheetSize: Double = 0.75
    
    init() {
        sheetSize = calculateSheetSize()
    }
    
    
    private func calculateSheetSize() -> Double {
        switch viewNumber {
        case 0:
            return 0.35
        case 1:
            return 0.75
        default:
            return 0.35
        }
    }
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
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.gray,lineWidth:1))
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
                
            }
            .sheet(isPresented: $viewModel.showSheet) {
                switch viewModel.viewNumber{
                case 0:
                    defaultSheetView()
                        .presentationDetents([.fraction(0.35), .medium])
                        .interactiveDismissDisabled()
                case 1:
                    DetailView()
                        .presentationDetents([.fraction(0.75), .fraction(0.75)])
                        .interactiveDismissDisabled()
                default:
                    ContentView()
                }
                
            }
        }.onAppear {
            quadtree.findNearestToilets(currentLocation: currentLocation, maxResults: 4)
        }
    }
}

#Preview {
    MainMapView()
        .environmentObject(PublicToiletManager())
    
}
