import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var showFullSizeImage = false
    @Published var selectedImageUrl: URL?
    @Published var timeTakenToArrive = 5
}

struct DetailView: View {
    var selectedToilet : PublicToilet
    @StateObject private var viewModel = DetailViewModel()
    @EnvironmentObject private var dataModel: PublicToiletManager
    
    var body: some View {
        NavigationStack {
            ZStack{
                ScrollView{
                    LazyVStack {
                        titleAndFavButtonView
                        imageScrollView
                        labelSection
                        timeAndDistanceView
                    }
                    .padding(.top, 20)
                }
                DirectionButtonView
            }
            .fullScreenCover(isPresented: $viewModel.showFullSizeImage) {
                if let url = viewModel.selectedImageUrl {
                    PhotoView(showFullSizeImage: $viewModel.showFullSizeImage,url: url)
                }
            }
        }
    }
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
            Text(selectedToilet.name ?? "No name")
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
            Text(selectedToilet.address ?? "No name")
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
                    ForEach(selectedToilet.image, id: \.self) { imageUrl in
                        imageNavigationLink(for: imageUrl)
                    }
                }
            }
        }
        .frame(height: 150)
    }
    
    // MARK: - Image Navigation Link
    private func imageNavigationLink(for imageUrl: String?) -> some View {
        guard
            let urlString = imageUrl,
            let url = URL(string: urlString)
        else {
            return AnyView(invalidImageView)
        }
        
        return AnyView(
            Button {
                viewModel.selectedImageUrl = url
                viewModel.showFullSizeImage = true
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
                .frame(width: 200, height: 150)
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
                .frame(width:130,height: 30)
                .foregroundColor(.gray)
            if let value = value {
                Text(value)
                
            }
        }
        .padding(.horizontal)
        .foregroundColor(.black)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    // MARK: - Get Labels
    private func getLabels() -> [(String, String?)] {
        var labels = [(String, String?)]()
        
        if let maleJapaneseStyle = selectedToilet.maleJapaneseStyle, maleJapaneseStyle > 0 {
            labels.append(("男性（和式）", "\(maleJapaneseStyle)"))
        }
        
        if let maleWesternStyle = selectedToilet.maleWesternStyle, maleWesternStyle > 0 {
            labels.append(("男性（洋式）", "\(maleWesternStyle)"))
        }
        
        if let femaleJapaneseStyle = selectedToilet.femaleJapaneseStyle, femaleJapaneseStyle > 0 {
            labels.append(("女性（和式）", "\(femaleJapaneseStyle)"))
        }
        
        if let femaleWesternStyle = selectedToilet.femaleWesternStyle, femaleWesternStyle > 0 {
            labels.append(("女性（洋式）", "\(femaleWesternStyle)"))
        }
        
        if let unisexJapaneseStyle = selectedToilet.unisexJapaneseStyle, unisexJapaneseStyle > 0 {
            labels.append(("男女共用（和式）", "\(unisexJapaneseStyle)"))
        }
        
        if let unisexWesternStyle = selectedToilet.unisexWesternStyle, unisexWesternStyle > 0 {
            labels.append(("男女共用（洋式）", "\(unisexWesternStyle)"))
        }
        
        if let multifunctionalToilets = selectedToilet.multifunctionalToilets, multifunctionalToilets > 0 {
            labels.append(("多機能トイレ数", "\(multifunctionalToilets)"))
        }
        
        if let wheelchairAccessible = selectedToilet.wheelchairAccessible, !wheelchairAccessible.isEmpty,
           wheelchairAccessible == "○" {
            labels.append(("車椅子使用者", nil))
        }
        
        if let infantFacilities = selectedToilet.infantFacilities, !infantFacilities.isEmpty,
           infantFacilities == "○" {
            labels.append(("乳幼児用設備設置", nil))
        }
        
        if let ostomateFacilities = selectedToilet.ostomateFacilities, !ostomateFacilities.isEmpty,
           ostomateFacilities == "○" {
            labels.append(("オストメイト設置", nil))
        }
        
        return labels
    }
    
    private var timeAndDistanceView: some View{
        VStack{
            HStack{
                Text("\(viewModel.timeTakenToArrive) 分")
                    .font(.system(size: 45))
                    .padding(.horizontal)
                Spacer()
            }
            HStack{
                Text("１km")
                
                Text(getArrivalTime(timeTakenToArrive: viewModel.timeTakenToArrive))
                Spacer()
                
            }
            .padding(.horizontal)
            .font(.headline)
        }
        
    }
    private var DirectionButtonView:some View{
        VStack{
            Spacer()
            Button {
                print("案内")
      
            } label: {
                Text("Direction")
                    .foregroundColor(.white)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)
            }
        }
    }
}


struct PhotoView: View {
    @Binding var showFullSizeImage:Bool
    var url: URL
    var body: some View {
        VStack{
            HStack{
                Button {
                    showFullSizeImage = false
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()

            }
            .padding()
            Spacer()
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .ignoresSafeArea()
            } placeholder: {
                Image("toilet-thumbnil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            }
            Spacer()
        }
    }
}




