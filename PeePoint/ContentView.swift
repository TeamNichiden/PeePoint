//
//  ContentView.swift
//  PeePoint
//
//  Created by Yuki Imai on 2024/08/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
@StateObject private var viewModel = PublicToiletManager()
  var body: some View {
    VStack {
//      Map()
//       .ignoresSafeArea(edges: .top)
//        .frame(height: 300)
      VStack(alignment: .leading) {
//          Text(viewModel.toilets[1].address)

        
         Text("Turtle Rock")
          .font(.title)
         HStack {
          Text("Joshua Tree National Park")
            .font(.subheadline)
          Spacer()
          Text("California")
            .font(.subheadline)
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
        Divider()
        Text("About Turtle Rock")
          .font(.title2)
        Text("Descriptive text goes here.")
      }
      .padding()
      Spacer()
    }
  }
}

#Preview {
    ContentView()
}
