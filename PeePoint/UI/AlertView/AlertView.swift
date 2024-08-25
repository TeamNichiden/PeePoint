//
//  AlertView.swift
//  PeePoint
//
//  Created by cmStudent on 2024/08/24.
//

import SwiftUI

struct AlertView: View {
    @State private var isAlert:Bool = false
    @State private var isReviewSheet:Bool = false
    var body: some View {
        VStack {
            //Test
            Button(action: {
                isAlert = true
            }) {
                Text("アラートを出す")
            }
        }.alert(isPresented: $isAlert) {
            Alert(title: Text("レビューのお願い"), message: Text("アプリの情報と現在のトイレの状況を一致させるため、最新の状況をレビューしていただきますか？"),
                  primaryButton: .default(Text("はい"),action: {
                    isReviewSheet = true
            }),
                  secondaryButton: .destructive(Text("いいえ"), action: {}))
        }
        .sheet(isPresented: $isReviewSheet) {
            CommentView(isReviewSheet: $isReviewSheet)
        }
    }
}

#Preview {
    AlertView()
}
