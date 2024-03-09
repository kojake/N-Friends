//
//  ProgressView.swift
//  N-Friend
//
//  Created by kaito on 2024/03/09.
//

import SwiftUI

struct Progressview: View {
    var body: some View {
        ZStack{
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack{
                ProgressView("ユーザー情報取得中")
                    .frame(width: 210, height: 100)
                    .background(Color.blue.opacity(0.9))
                    .foregroundColor(Color.white)
                    .tint(Color.white)
                    .cornerRadius(14)
            }
        }
    }
}
