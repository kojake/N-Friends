//
//  UserDetailView.swift
//  N-Friend
//
//  Created by kaito on 2024/03/23.
//

import SwiftUI

struct UserDetailView: View {
    var UserProfile: UserModel = UserModel(UID: "ARFS8MLPbwOPUYsVmpz8ZRxkEoj2", Username: "aaa", EnrollmentCampus: "秋葉原", Tastes: ["サッカー"])
    
    var body: some View {
        VStack{
            HStack{
                Image("Person1").resizable().frame(width: 100, height: 100).cornerRadius(75).overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.black, lineWidth: 2)).padding()
                VStack(alignment: .leading ){
                    Text(UserProfile.Username).font(.title).fontWeight(.semibold)
                    Text("@\(UserProfile.UID)").font(.system(size: 13))
                }
                Spacer()
            }
            Spacer()
            NavigationView{
                Form{
                    Section{
                        HStack {
                            VStack{
                                Image(systemName: "person.text.rectangle").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.blue)
                            }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                            Text(UserProfile.Username).fontWeight(.semibold)
                        }
                        HStack{
                            VStack{
                                Image(systemName: "mappin.and.ellipse").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.green)
                            }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                            Text("\(UserProfile.EnrollmentCampus)キャンパス").fontWeight(.semibold)
                        }
                        HStack {
                            VStack{
                                Image(systemName: "gamecontroller").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.pink)
                            }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                            Text("趣味")
                                .fontWeight(.semibold)
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(0..<UserProfile.Tastes.count, id: \.self) { index in
                                        Text(UserProfile.Tastes[index]).fontWeight(.semibold).frame(width: 130, height: 30).background(Color.blue).foregroundColor(Color.white).cornerRadius(5)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

#Preview {
    UserDetailView()
}
