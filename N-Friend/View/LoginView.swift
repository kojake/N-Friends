//
//  LoginView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct LoginView: View {
    
    
    var body: some View {
        ZStack{
            Color.blue.opacity(0.7).ignoresSafeArea()
            VStack{
                Text("N-Friends").font(.largeTitle).fontWeight(.black).padding()
                Spacer()
                Button(action: {
                    
                }){
                    HStack{
                        Image("Google").resizable().scaledToFit().frame(width: 45, height: 45)
                        Text("Googleでログインする").fontWeight(.bold).foregroundColor(Color.black)
                    }.frame(width: 280, height: 60).background(Color.white).cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    
                }){
                    Text("ログインできませんか？").font(.title2).foregroundColor(Color.white)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
