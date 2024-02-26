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
                    }.frame(width: 60, height: 60).background(Color.gray).cornerRadius(10)
                    Text("ユーザーネームの変更")
                }
            }.navigationTitle("Edit Profile")
        }
    }
}

#Preview {
    EditProfileView()
}
