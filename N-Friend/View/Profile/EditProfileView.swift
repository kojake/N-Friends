//
//  EditProfileView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/26.
//

import SwiftUI

struct EditProfileView: View {
    
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: EditUsernameView()){
                    VStack{
                        Image(systemName: "person.text.rectangle").resizable().scaledToFit().frame(width: 45, height: 45).foregroundColor(Color.white)
                    }.frame(width: 60, height: 60).background(Color.blue).cornerRadius(10)
                    Text("ユーザーネームの変更")
                }
                NavigationLink(destination: EditCampusView()){
                    VStack{
                        Image(systemName: "mappin.and.ellipse").resizable().scaledToFit().frame(width: 45, height: 45).foregroundColor(Color.white)
                    }.frame(width: 60, height: 60).background(Color.mint).cornerRadius(10)
                    Text("キャンパス変更")
                }
                NavigationLink(destination: EditInterestView()){
                    VStack{
                        Image(systemName: "gamecontroller.fill").resizable().scaledToFit().frame(width: 45, height: 45).foregroundColor(Color.white)
                    }.frame(width: 60, height: 60).background(Color.pink).cornerRadius(10)
                    Text("興味/趣味の変更")
                }
            }.navigationTitle("Edit Profile")
        }
    }
}

#Preview {
    EditProfileView()
}
