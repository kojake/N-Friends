//
//  FindingFriendsView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct CardSwipeView: View {
    var body: some View {
        ZStack{
            VStack{
                Text("N-Friends").font(.largeTitle).fontWeight(.black)
                Spacer()
                CardView()
                Spacer()
                HStack{
                    Button(action: {
                        
                    }){
                        VStack{
                            VStack{
                                Image(systemName: "xmark").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.white)
                            }.frame(width: 70, height: 70).background(Color.red.opacity(0.9)).cornerRadius(50)
                            Text("DISLIKE").font(.title).fontWeight(.bold).foregroundColor(Color.red)
                        }
                    }.padding()
                    Button(action: {
                        
                    }){
                        VStack{
                            VStack{
                                Image(systemName: "heart.fill").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.white)
                            }.frame(width: 70, height: 70).background(Color.green.opacity(0.9)).cornerRadius(50)
                            Text("LIKE").font(.title).fontWeight(.bold).foregroundColor(Color.green)
                        }
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    CardSwipeView()
}
