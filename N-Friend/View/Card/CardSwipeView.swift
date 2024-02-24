//
//  FindingFriendsView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct CardSwipeView: View {
    
    var body: some View {
        VStack{
            Text("N-Friends").font(.largeTitle).fontWeight(.black)
            Spacer()
            CardView()
            Spacer()
            HStack{
                Button(action: {
                    
                }){
                    VStack{
                        Image(systemName: "xmark").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.white)
                    }.frame(width: 70, height: 70).background(Color.red.opacity(0.9)).cornerRadius(50)
                }
                Button(action: {
                    
                }){
                    VStack{
                        Image(systemName: "star.fill").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.white)
                    }.frame(width: 60, height: 60).background(Color.blue.opacity(0.9)).cornerRadius(50)
                }.padding()
                Button(action: {
                    
                }){
                    VStack{
                        Image(systemName: "heart.fill").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.white)
                    }.frame(width: 70, height: 70).background(Color.green.opacity(0.9)).cornerRadius(50)
                }
            }.padding()
        }
    }
}

#Preview {
    CardSwipeView()
}
