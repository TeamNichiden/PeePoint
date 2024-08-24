import SwiftUI

struct DetailView: View {
    
    @State var index: Int = 860
    @State var timeTakenToArrive = 5
    @EnvironmentObject private var dataModel: PublicToiletManager
    
    var body: some View {
        NavigationStack {
            ScrollView{
                LazyVStack {
                    titleAndFavButtonView
                    imageScrollView
                    labelSection
                    
                    HStack{
                        Text("\(timeTakenToArrive) 分")
                            .font(.system(size: 45))
                            .padding(.horizontal)
                        Spacer()
                    }
                    HStack{
                        Text("１km")
                            
                        Text(getArrivalTime(timeTakenToArrive: timeTakenToArrive))
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    .font(.headline)

                   
                    
                }
                .padding(.top, 20)
            }
        }

    }
}

#Preview {
    DetailView()
        .environmentObject(PublicToiletManager())
}
//FUNCTIONS
extension DetailView{
    private func getArrivalTime(timeTakenToArrive : Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Change format as needed
        
        let currentDate = Date()
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .minute, value: timeTakenToArrive, to: currentDate) {
            return dateFormatter.string(from: newDate)
        }
        return dateFormatter.string(from: currentDate) // Fallback in case of error
    }
}


//VIEWS
extension DetailView{
    private var TitelAndFavButtonView: some View{
        HStack {
            Text(dataModel.toilets[index].name ?? "No name")
                .font(.title)
                .frame(width: 350)
            Spacer()
            Image(systemName: "heart")
                .font(.system(size: 25))
                .padding(.trailing)
        }
        
    }
    // MARK: - Title and Favorite Button View
    private var titleAndFavButtonView: some View {
        HStack {
            Text(dataModel.toilets[index].address ?? "No name")
                .font(.title)

            Spacer()
            //            Image(systemName: "star")
            Image(systemName: "heart")
                .font(.system(size: 25))
                .padding(.trailing)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Image Scroll View
    private var imageScrollView: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(dataModel.toilets[index].image, id: \.self) { imageUrl in
                        imageNavigationLink(for: imageUrl)
                    }
                }
            }
        }
        .frame(height: 150)
    }
    
    // MARK: - Image Navigation Link
    private func imageNavigationLink(for imageUrl: String?) -> some View {
        guard let urlString = imageUrl, let url = URL(string: urlString) else {
            return AnyView(
                invalidImageView
            )
        }
        
        return AnyView(
            NavigationLink {
                fullImageView(url: url)
            } label: {
                thumbnailImageView(url: url)
            }
        )
    }
    
    // MARK: - Invalid Image View
    private var invalidImageView: some View {
        ForEach(1..<4, id: \.self) { _ in
            Image("toilet-thumbnil")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 150)
        }
        
    }
    
    // MARK: - Thumbnail Image View
    private func thumbnailImageView(url: URL) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
        } placeholder: {
            placeholderImageView
        }
    }
    
    // MARK: - Full Image View
    private func fullImageView(url: URL) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
        } placeholder: {
            placeholderImageView
        }
    }
    
    // MARK: - Placeholder Image View
    private var placeholderImageView: some View {
        Image("toilet-thumbnil")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
    }
    
    // MARK: - Label Section
    private var labelSection: some View {
        let labels = getLabels()
        
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], alignment: .leading) { // Make sure alignment is leading here if needed
            ForEach(0..<labels.count, id: \.self) { i in
                labelView(label: labels[i].0, value: labels[i].1)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align content to leading
                    .frame(height:30)
            }
        }
        .padding(.horizontal, 10)
    }

    // MARK: - Label View
    private func labelView(label: String, value: String?) -> some View {
        HStack {
            Text(label)
                .frame(width:140,height: 30)
            if let value = value {
                Text(value)
                
            }
        }
        .padding(.horizontal)
        .foregroundColor(.black)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 3)
        )
    }
    
    // MARK: - Get Labels
    private func getLabels() -> [(String, String?)] {
        var labels = [(String, String?)]()
        
        if let maleJapaneseStyle = dataModel.toilets[index].maleJapaneseStyle, maleJapaneseStyle > 0 {
            labels.append(("男性トイレ数（和式）", "\(maleJapaneseStyle)"))
        }
        
        if let maleWesternStyle = dataModel.toilets[index].maleWesternStyle, maleWesternStyle > 0 {
            labels.append(("男性トイレ数（洋式）", "\(maleWesternStyle)"))
        }
        
        if let femaleJapaneseStyle = dataModel.toilets[index].femaleJapaneseStyle, femaleJapaneseStyle > 0 {
            labels.append(("女性トイレ数（和式）", "\(femaleJapaneseStyle)"))
        }
        
        if let femaleWesternStyle = dataModel.toilets[index].femaleWesternStyle, femaleWesternStyle > 0 {
            labels.append(("女性トイレ数（洋式）", "\(femaleWesternStyle)"))
        }
        
        if let unisexJapaneseStyle = dataModel.toilets[index].unisexJapaneseStyle, unisexJapaneseStyle > 0 {
            labels.append(("男女共用トイレ数（和式）", "\(unisexJapaneseStyle)"))
        }
        
        if let unisexWesternStyle = dataModel.toilets[index].unisexWesternStyle, unisexWesternStyle > 0 {
            labels.append(("男女共用トイレ数（洋式）", "\(unisexWesternStyle)"))
        }
        
        if let multifunctionalToilets = dataModel.toilets[index].multifunctionalToilets, multifunctionalToilets > 0 {
            labels.append(("多機能トイレ数", "\(multifunctionalToilets)"))
        }
        
        if let wheelchairAccessible = dataModel.toilets[index].wheelchairAccessible, !wheelchairAccessible.isEmpty,
           wheelchairAccessible == "○" {
            labels.append(("車椅子使用者", nil))
        }
        
        if let infantFacilities = dataModel.toilets[index].infantFacilities, !infantFacilities.isEmpty,
           infantFacilities == "○" {
            labels.append(("乳幼児用設備設置", nil))
        }
        
        if let ostomateFacilities = dataModel.toilets[index].ostomateFacilities, !ostomateFacilities.isEmpty,
           ostomateFacilities == "○" {
            labels.append(("オストメイト設置", nil))
        }
        
        return labels
    }

        
}






