//
//  CardView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct CardView: View {
    var UserList: [UserModel]
    
    var body: some View {
        GeometryReader{ geo in
//            ForEach(UserList) { model in
//                ZStack{
//                    Image("Person1").resizable().scaledToFit().frame(height: geo.size.height - 200).cornerRadius(20).padding(.horizontal, 15)
//                    VStack{
//                        Spacer()
//                        HStack{
//                            VStack(alignment: .leading){
//                                Text(model.Username).font(.system(size: 40)).fontWeight(.bold)
//                                Text("趣味").font(.title2)
//                                ScrollView(.horizontal){
//                                    HStack{
//                                        ForEach(0..<model.Tastes.count, id: \.self) { index in
//                                            Text(model.Tastes[index]).frame(width: 150, height: 50).background(Color.blue.opacity(0.5)).foregroundColor(Color.white).cornerRadius(7)
//                                        }
//                                    }
//                                }
//                            }.padding()
//                        }
//                    }.frame(width: geo.size.width - 32, height: geo.size.height - 250).background(Color.black.opacity(0.2)).foregroundColor(Color.white)
//                }
//            }
        }
    }
}
