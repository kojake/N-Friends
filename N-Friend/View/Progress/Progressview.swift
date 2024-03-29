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
                ProgressView("しばらくお待ちください")
                    .frame(width: 210, height: 100)
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
    Progressview()
}
