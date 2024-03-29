//
//  AccountCreateProgressView.swift
//  N-Friend
//
//  Created by kaito on 2024/03/29.
//

import SwiftUI

struct AccountCreateProgressView: View {
    var body: some View {
        ZStack{
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack{
                ProgressView("作成中")
                    .frame(width: 100, height: 100)
                    .background(Color.black.opacity(0.9))
                    .foregroundColor(Color.white)
                    .tint(Color.white)
                    .font(.custom("KohinoorTelugu-Medium", size: 16))
                    .cornerRadius(4)
            }
        }
    }
}

#Preview {
    AccountCreateProgressView()
}
