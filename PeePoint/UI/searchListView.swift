//
//  searchListView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/24.
//

import SwiftUI

//SearchBar_Sample
struct searchListView: View {
    @Binding var isPresented:Bool
    @Binding var showDetailView:Bool
    @Binding var selectedToilet:PublicToilet?
    @State var searchText = ""
    @EnvironmentObject private var dataModel: PublicToiletManager
    @StateObject private var viewModel = MapViewModel()
    
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
    
    @State private var isTap:Bool = true
    @FocusState private var focused : Bool
    var body: some View {
        VStack{
            HStack{
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .padding()
                        .foregroundColor(.black)
                }
                
                
                Spacer()
            }
            TextField("検索",text: $searchText)
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
            
            
            Spacer()
            
            List(dataModel.toilets,id:\.self){toilet in
                Text(toilet.address ?? "名前なし")
                    .onTapGesture {
                        isPresented = false
                        showDetailView = true
                        selectedToilet = toilet
                    }
            }
        }
    }
}

extension Color {
    static var backgroundColor:Color {
        return Color(red:0.9,green:0.9,blue:0.9)
    }
}
