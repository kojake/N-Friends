//
//  FindingFriendsView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct CardSwipeView: View {
    @State var CardUserList: [UserModel] = [
        UserModel(Username: "a", EnrollmentCampus: "秋葉原", Tastes: ["スポーツ"], Status: "", Swipe: 0, degrees: 0),
        UserModel(Username: "b", EnrollmentCampus: "新宿", Tastes: ["スポーツ"], Status: "", Swipe: 0, degrees: 0),
        UserModel(Username: "c", EnrollmentCampus: "代々木", Tastes: ["スポーツ"], Status: "", Swipe: 0, degrees: 0)
    ]
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                HStack{
                    Spacer()
                    Text("N-Friends").font(.largeTitle).fontWeight(.black)
                    Spacer()
                }
                Spacer()
                ZStack{
                    ForEach(CardUserList) { model in
                        if model.Status == ""{
                            ZStack{
                                Image("Person1").resizable().scaledToFit().frame(height: geo.size.height - 200).cornerRadius(20).padding(.horizontal, 15)
                                VStack{
                                    Spacer()
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text(model.Username).font(.system(size: 40)).fontWeight(.bold)
                                            Text("趣味").font(.title2)
                                            ScrollView(.horizontal){
                                                HStack{
                                                    ForEach(0..<model.Tastes.count, id: \.self) { index in
                                                        Text(model.Tastes[index]).frame(width: 150, height: 50).background(Color.blue.opacity(0.5)).foregroundColor(Color.white).cornerRadius(7)
                                                    }
                                                }
                                            }
                                        }.padding()
                                    }
                                }.frame(width: geo.size.width - 32, height: geo.size.height - 250).background(Color.black.opacity(0.2)).foregroundColor(Color.white)
                            }.gesture(DragGesture() 
                                .onChanged({ (value) in
                                    if value.translation.width > 0 {
                                        if let cardindex = CardUserList.indices.last{
                                            CardUserList[cardindex].Swipe = value.translation.width
                                            CardUserList[cardindex].degrees = 8
                                        }
                                    } else {
                                        if let cardindex = CardUserList.indices.last{
                                            CardUserList[cardindex].Swipe = value.translation.width
                                            CardUserList[cardindex].degrees = -8
                                        }
                                    }
                                }).onEnded({ (value) in
                                    if model.Swipe > 0 {
                                        if model.Swipe > geo.size.width / 2 - 80{
                                            if let cardindex = CardUserList.indices.last{
                                                CardUserList[cardindex].Swipe = 500
                                                CardUserList[cardindex].degrees = 8
                                                
                                                CardUserList.remove(at: cardindex)
                                            }
                                        } else {
                                            if let cardindex = CardUserList.indices.last{
                                                CardUserList[cardindex].Swipe = 0
                                                CardUserList[cardindex].degrees = 0
                                            }
                                        }
                                    } else {
                                        if -model.Swipe > geo.size.width / 2 - 80{
                                            if let cardindex = CardUserList.indices.last{
                                                CardUserList[cardindex].Swipe = -700
                                                CardUserList[cardindex].degrees = 8
                                                
                                                CardUserList.remove(at: cardindex)
                                            }
                                        } else {
                                            if let cardindex = CardUserList.indices.last{
                                                CardUserList[cardindex].Swipe = 0
                                                CardUserList[cardindex].degrees = 0
                                            }
                                        }
                                    }
                                })
                            ).offset(x: model.Swipe)
                                .rotationEffect(.init(degrees: model.degrees))
                                .animation(.spring())
                        }
                    }
                }
                Spacer()
                HStack{
                    Button(action: {
                        if let cardindex = CardUserList.indices.last{
                            CardUserList[cardindex].Status = "Liked"
                            CardUserList.remove(at: cardindex)
                        }
                    }){
                        VStack{
                            VStack{
                                Image(systemName: "xmark").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.white)
                            }.frame(width: 70, height: 70).background(Color.red.opacity(0.9)).cornerRadius(50)
                            
                        }
                    }.padding()
                    Button(action: {
                        if let cardindex = CardUserList.indices.last{
                            CardUserList[cardindex].Status = "DisLikeda"
                            CardUserList.remove(at: cardindex)
                        }
                    }){
                        VStack{
                            VStack{
                                Image(systemName: "heart.fill").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.white)
                            }.frame(width: 70, height: 70).background(Color.green.opacity(0.9)).cornerRadius(50)
                            
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
