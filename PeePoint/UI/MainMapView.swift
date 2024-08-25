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
    @StateObject private var routeModel = MapRouteModel()
    private var locationManager = CLLocationManager()
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917),
                latitudinalMeters: 500,
                longitudinalMeters: 500
            ))
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
    
    @State var showSearchView:Bool = false
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                UserAnnotation()
                ForEach(quadtree.toilets) { location in
                    
                    Annotation(location.name ?? "", coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)){
                        VStack{
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 5, height: 5)
                        }
                    }
                }
                if let route = routeModel.route {
                    MapPolyline(route)
                        .stroke(Color.blue, lineWidth: 5)
                }
            }
            VStack{
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



                
                Spacer()
                ShowNearbyListButtonView
                
            }
            
            
            
        }
        .sheet(isPresented: $viewModel.showNearbyToiletSheet) {
            defaultSheetView(
                showNearbyToiletSheet: $viewModel.showNearbyToiletSheet, selectedToilet: $viewModel.selectedToilet,
                showDetailView: $viewModel.showDetailView,
                nearestToilets: quadtree.nearestToilets
            )
            .presentationDetents([.fraction(0.58)])

        }
        
        .sheet(isPresented: $viewModel.showDetailView) {
            if let selectedToilet = viewModel.selectedToilet {
                DetailView(selectedToilet: selectedToilet) // Use the correct label
                    .presentationDetents([.fraction(0.75)])
            }
        }
        .fullScreenCover(isPresented: $showSearchView, content: {
            searchListView(isPresented: $showSearchView, showDetailView: $viewModel.showDetailView, selectedToilet:$viewModel.selectedToilet)
        })
        .onAppear(){
                    if let currentLocation = locationManager.location {
                        quadtree.findNearestToilets(currentLocation: currentLocation, maxResults: 4)
                    }
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
