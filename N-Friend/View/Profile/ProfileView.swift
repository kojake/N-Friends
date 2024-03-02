//
//  ProfileView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    var Realname: String
    
    //Profile
    @State var Username: String = ""
    @State var Campus: String = "秋葉原"
    
    @State var Tastes: [String] = ["サッカー", "バスケ", "プログラミング"]
    @State private var Showshould_TastesEditView = false
    
    //Picker
    @State var CurrentAllCampus: [String] = ["秋葉原", "代々木", "新宿"]
    @State var SelectionIndexValue: Int = 0
    
    //Signout
    @State private var Signoutalert = false
    @State private var Showshould_LoginView = false
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Image("Person1")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(75)
                        .overlay(
                            RoundedRectangle(cornerRadius: 75).stroke(Color.black, lineWidth: 2))
                    HStack{
                        Rectangle().frame(width: 50, height: 1).foregroundColor(.clear)
                        VStack{
                            Rectangle().frame(width: 1, height: 50).foregroundColor(.clear)
                            Button(action: {
                                
                            }){
                                ZStack{
                                    Image(systemName: "plus").foregroundColor(Color.white)
                                }.frame(width: 30, height: 30).background(Color.blue).cornerRadius(50)
                            }
                        }
                    }
                }
                NavigationView{
                    Form{
                        Section{
                            HStack {
                                VStack{
                                    Image(systemName: "person.text.rectangle").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.blue)
                                }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                                Text("ユーザーネーム")
                                    .fontWeight(.semibold)
                                TextField(Username, text: $Username)
                            }
                            HStack{
                                VStack{
                                    Image(systemName: "mappin.and.ellipse").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.green)
                                }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                                Picker("所属キャンパス", selection: $SelectionIndexValue) {
                                    ForEach(0..<CurrentAllCampus.count, id: \.self){ index in
                                        Text(CurrentAllCampus[index]).tag(index)
                                    }
                                }.fontWeight(.semibold)
                            }
                            HStack {
                                VStack{
                                    Image(systemName: "gamecontroller").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.pink)
                                }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                                Text("趣味")
                                    .fontWeight(.semibold)
                                ScrollView(.horizontal){
                                    HStack{
                                        ForEach(0..<Tastes.count, id: \.self) { index in
                                            Text(Tastes[index]).fontWeight(.semibold).frame(width: 130, height: 30).background(Color.blue).foregroundColor(Color.white).cornerRadius(5)
                                        }
                                    }
                                }
                            }.onTapGesture {
                                Showshould_TastesEditView = true
                            }
                        }
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .keyboard) {
                Button("閉じる") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .onAppear{
            UsernameGet()
        }
        .onDisappear{
            UsernameUpdate()
        }
        .alert(isPresented: $Signoutalert) {
            Alert(title: Text("確認"),
                  message: Text("本当にサインアウトしますか？"),
                  primaryButton: .cancel(Text("キャンセル")),
                  secondaryButton: .default(Text("サインアウト"),
                                            action: {
                Showshould_LoginView = true
            }))
        }
        .navigationDestination(isPresented: $Showshould_LoginView) {
            LoginView()
        }
        .sheet(isPresented: $Showshould_TastesEditView){
            TastesEditView()
        }
    }
    private func UsernameGet(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(Realname).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["Username"] as? String {
                    Username = fieldValue
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    private func UsernameUpdate(){
         let db = Firestore.firestore()
         
         // フィールドの値を更新
         db.collection("UserList").document(Realname).updateData([
             "Username": Username
         ]) { err in
             if let err = err {
                 print("Error updating document: \(err)")
             } else {
                 print("Document successfully updated")
             }
         }
     }
}
