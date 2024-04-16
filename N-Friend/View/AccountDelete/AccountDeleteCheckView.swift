//
//  AccountDeleteCheckView.swift
//  N-Friend
//
//  Created by kaito on 2024/04/16.
//

import SwiftUI

struct AccountDeleteCheckView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @State var Username: String
    @State var UserUID: String
    
    @State private var Showshould_LoginToDeleteView = false
    
    var body: some View {
        VStack{
            NavigationLink(destination: LoginToDeleteView(UserUID: UserUID, Username: Username), isActive: $Showshould_LoginToDeleteView){
                EmptyView()
            }
            
            Image(systemName: "exclamationmark.triangle.fill").resizable().scaledToFit().frame(width: 80, height: 80).foregroundColor(Color.yellow)
            Text("警告").font(.title).fontWeight(.bold)
            Text("アカウントを削除すると次の内容が\n削除されます。").font(.title2).fontWeight(.bold).padding()
            VStack(alignment: .leading){
                HStack{
                    VStack{
                        Image(systemName: "person.fill").resizable().scaledToFit().frame(width: 25, height: 25).foregroundColor(Color.blue)
                    }.frame(width: 50, height: 50).background(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.3)).cornerRadius(50)
                    Text("プロフィール内の情報").font(.title2).fontWeight(.regular)
                }
                HStack{
                    VStack{
                        Image(systemName: "heart.fill").resizable().scaledToFit().frame(width: 25, height: 25).foregroundColor(Color.pink)
                    }.frame(width: 50, height: 50).background(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.3)).cornerRadius(50)
                    Text("Like、Matchしたユーザーリスト").font(.title3).fontWeight(.regular)
                }
            }
            Spacer()
            Text("削除しますか？").font(.title)
            HStack{
                Button(action: {
                    dismiss()
                }){
                    Text("キャンセル").font(.title2).fontWeight(.semibold).frame(width: 150, height: 50).background(Color.blue).foregroundColor(Color.white).cornerRadius(5)
                }.padding()
                Button(action: {
                    Showshould_LoginToDeleteView = true
                }){
                    Text("削除").font(.title2).fontWeight(.semibold).frame(width: 150, height: 50).background(Color.red).foregroundColor(Color.white).cornerRadius(5)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AccountDeleteCheckView(Username: "", UserUID: "")
}
