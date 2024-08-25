import SwiftUI

struct searchListView: View {
    @Binding var isPresented: Bool
    @Binding var showDetailView: Bool
    @Binding var selectedToilet: PublicToilet?
    @Binding var filterByWheelchairAccessible: Bool
    @Binding var filterByInfantFacilities: Bool
    @Binding var filterByOstomateFacilities: Bool
    @Binding var filterByunisexJapaneseStyle: Bool
    @Binding var filterByunisexWesternStyle: Bool
    @Binding var filterBymultifunctionalToilets: Bool
    @State var searchText = ""
    @EnvironmentObject private var dataModel: PublicToiletManager

    var body: some View {
        VStack {
            HStack {
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
            
            TextField("検索", text: $searchText)
                .padding(.leading)
                .font(.headline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 55)
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                .shadow(radius: 10, y: 5)
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack {
                    Button(action: {
                        filterByWheelchairAccessible.toggle()
                    }) {
                        Text("車椅子対応")
                            .padding(.horizontal)
                            .frame(height: 26)
                            .foregroundColor(filterByWheelchairAccessible ? .white : .black)
                            .background(filterByWheelchairAccessible ? Color.blue : Color.white)
                            .cornerRadius(13)
                    }
                    
                    Button(action: {
                        filterByInfantFacilities.toggle()
                    }) {
                        Text("乳幼児用設備")
                            .padding(.horizontal)
                            .frame(height: 26)
                            .foregroundColor(filterByInfantFacilities ? .white : .black)
                            .background(filterByInfantFacilities ? Color.blue : Color.white)
                            .cornerRadius(13)
                    }
                    Button(action: {
                        filterByunisexJapaneseStyle.toggle()
                    }) {
                        Text("和式")
                            .padding(.horizontal)
                            .frame(height: 26)
                            .foregroundColor(filterByunisexJapaneseStyle ? .white : .black)
                            .background(filterByunisexJapaneseStyle ? Color.blue : Color.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        filterByOstomateFacilities.toggle()
                    }) {
                        Text("オストメイト設備")
                            .padding(.horizontal)
                            .frame(height: 26)
                            .foregroundColor(filterByOstomateFacilities ? .white : .black)
                            .background(filterByOstomateFacilities ? Color.blue : Color.white)
                            .cornerRadius(13)
                    }
                    Button(action: {
                        filterByunisexWesternStyle.toggle()
                    }) {
                        Text("洋式")
                            .padding(.horizontal)
                            .frame(height: 26)
                            .foregroundColor(filterByunisexWesternStyle ? .white : .black)
                            .background(filterByunisexWesternStyle ? Color.blue : Color.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        filterBymultifunctionalToilets.toggle()
                    }) {
                        Text("多機能")
                            .padding(.horizontal)
                            .frame(height: 26)
                            .foregroundColor(filterBymultifunctionalToilets ? .white : .black)
                            .background(filterBymultifunctionalToilets ? Color.blue : Color.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            Text("\(filteredToilets.count.description)個トイレが見つかりました。")
                .font(.caption)
                
            List(filteredToilets, id: \.self) { toilet in
                Text(toilet.address ?? "名前なし")
                    .onTapGesture {
                        isPresented = false
                        showDetailView = true
                        selectedToilet = toilet
                    }
            }
        }
    }
    
    private var filteredToilets: [PublicToilet] {
        dataModel.toilets.filter { toilet in
            (!filterByWheelchairAccessible || toilet.wheelchairAccessible == "○") &&
            (!filterByInfantFacilities || toilet.infantFacilities == "○") &&
            (!filterByOstomateFacilities || toilet.ostomateFacilities == "○") &&
            (!filterByunisexJapaneseStyle || toilet.unisexJapaneseStyle ?? 0 > 0) &&
            (!filterByunisexWesternStyle || toilet.unisexWesternStyle ?? 0 > 0) &&
            (!filterBymultifunctionalToilets || toilet.multifunctionalToilets ?? 0 > 0)
        }
    }
}
