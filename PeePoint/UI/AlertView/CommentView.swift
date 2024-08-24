//
//  CommentView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/24.
//

import SwiftUI

struct CommentView: View {
    @State private var reviewStars: [Bool] = [false, false, false, false, false]
    
    @State private var isOn: Bool = false
    @State private var reviewText: String = UserDefaults.standard.string(forKey: "reviewText") ?? ""
    
    @Binding var isReviewSheet: Bool
    @State private var count:Int = 0
    @State private var maxCount:Int = 1000
    
    var body: some View {
        VStack(alignment: .leading) {
            //Sample
            HStack {
                Text("公園")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    isReviewSheet = false
                }) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.black)
                }
            }
            Spacer()
            HStack {
                Text("評価")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                HStack {
                    ForEach(0..<reviewStars.count, id: \.self) { index in
                        Button(action: {
                            for i in 0...index {
                                reviewStars[i] = true
                            }
                        }) {
                            Image(systemName: reviewStars[index] ? "star.fill" : "star")
                                .foregroundColor(reviewStars[index] ? Color.yellow : Color.black)
                        }
                    }
                    
                }
                .frame(width:UIScreen.main.bounds.width/3)
            }
            .padding(.vertical)
            HStack {
                Toggle(isOn:$isOn) {
                    Text("アプリの情報通りでしたか？")
                }
            }
            Text("そうでなかった場合")
                .padding(.vertical)
            //保存場所
            TextEditor(text: $reviewText)
                .background(.white)
                .border(.gray)
                .frame(height: 100)
                .onChange(of: reviewText) {
                    UserDefaults.standard.set(reviewText, forKey: "reviewText")
                }
            
            Text("追記（ある場合で構いません）")
                .padding(.vertical)
            //保存場所
            TextEditor(text: $reviewText)
                .background(.white)
                .border(.gray)
                .frame(height: 150)
                .onChange(of: reviewText) {
                    UserDefaults.standard.set(reviewText, forKey: "reviewText")
                }
            HStack {
                Spacer()
                Text("\(count)/\(String(maxCount))")
                    .opacity(0.5)
            }
            Spacer()
            Button(action: {
                isReviewSheet = false
            }) {
                Text("完了")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical,10)
                    .padding(.horizontal,150)
                    .background(.blue)
                    .cornerRadius(30)
            }
        }
        .frame(width:UIScreen.main.bounds.width-50,height: UIScreen.main.bounds.height-120)
    }
}

#Preview {
    CommentView(isReviewSheet: .constant(true))
}
