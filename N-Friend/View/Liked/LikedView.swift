//
//  StarView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore

struct LikedView: View {
    @State var UserUID: String
    
    @State var LikeUser: [String] = []
    @State private var Showshould_UserDetailView = false
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    ForEach(0..<LikeUser.count, id: \.self) { index in
                        VStack {
                            Image("Person1").resizable().scaledToFit().frame(width: 180, height: 250).cornerRadius(10)
                            Text(LikeUser[index]).font(.title3).fontWeight(.black).foregroundColor(Color.black)
                            Spacer()
                        }.frame(width: 230, height: 300).background(Color.blue.opacity(0.3)).cornerRadius(10)
                            .onTapGesture {
                                Showshould_UserDetailView = true
                            }
                            .contextMenu {
                                Button(action: {
                                    Showshould_UserDetailView = true
                                }){
                                    Text("アカウント表示")
                                }
                                Button(action: {
                                    LikeUser.remove(at: index)
                                    UpdateLikeUser()
                                }){
                                    Text("削除")
                                }
                            }
                    }
                }
            }
            .navigationTitle(Text("\(LikeUser.count) 「👍Like!」"))
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear{
            FetchLikeUser()
            //存在するLikeUser分UIDを関数に渡す
            for i in 0..<LikeUser.count{
                FetchLikeUsername(UID: LikeUser[i], index: i)
            }
        }
        .sheet(isPresented: $Showshould_UserDetailView){
            UserDetailView()
        }
    }
    private func FetchLikeUser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["LikeUser"] as? [String] {
                    LikeUser = fieldValue
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    private func FetchLikeUsername(UID: String, index: Int){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["Username"] as? String {
                    LikeUser[index] = fieldValue
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    private func UpdateLikeUser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).updateData([
            "LikeUser": LikeUser
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
