//
//  searchListView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/24.
//

import SwiftUI

struct searchListView: View {
    var viewMNumber : Int = 0
    
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
    
    @State private var isTap:Bool = false
    
    var body: some View {
        ZStack{
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
        }
    }
}

#Preview {
    searchListView()
}
