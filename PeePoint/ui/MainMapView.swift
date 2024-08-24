//
//  MainMapView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/24.
//

import SwiftUI
import MapKit

struct MainMapView: View {
    @State private var searchText = ""
    let spotlist = [
        Spot(name: "TokyoTower", lat: 35.6586, long: 139.7454)
    ]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6586, longitude: 139.7454),
        latitudinalMeters: 1000.0,
        longitudinalMeters: 1000.0
    )
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                annotationItems: spotlist,
                annotationContent: { spot in
                
                MapMarker(coordinate: spot.coordinate, tint: .red)
            })
            .edgesIgnoringSafeArea(.all)
            VStack {
                TextField("検索",text: $searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
}

struct Spot: Identifiable {
    let id = UUID()
    var name: String?
    var lat: Double
    var long: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

#Preview {
    MainMapView()
}
