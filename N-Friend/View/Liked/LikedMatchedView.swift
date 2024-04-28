//
//  StarView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct LikedMatchedView: View {
    @State var TapUserUID: String = ""
    @State var UserUID: String
    
    @State var LikeUserUIDList: [String] = []
    @State var LikeUser: [LikeCardUserModel] = []
    @State var DisLikeUserUIDList: [String] = []
    @State var MatchUserUIDList: [String] = []
    @State var MatchUser: [MatchCardUserModel] = []
    @State private var Showshould_UserDetailView = false
    
    @State private var SelectedIndex: Int = 0
    
    var body: some View {
        NavigationView{
            VStack{
                Picker("", selection: $SelectedIndex) {
                    Text("👍Like")
                        .tag(0)
                    Text("❤️Match")
                        .tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
                ZStack{
                    ScrollView{
                        if SelectedIndex == 0 {
                            ForEach(0..<LikeUser.count, id: \.self) { index in
                                ZStack {
                                    Image(uiImage: LikeUser[index].UserImage).resizable().frame(width: 230, height: 300).cornerRadius(10)
                                    VStack{
                                        Spacer()
                                        Text(LikeUser[index].Username).frame(width: 230, height: 50).background(Color.white.opacity(0.6)).font(.title).fontWeight(.black).foregroundColor(Color.black)
                                    }
                                }.frame(width: 230, height: 300).cornerRadius(10)
                                    .onTapGesture {
                                        TapUserUID = LikeUser[index].UID
                                        Showshould_UserDetailView = true
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            Showshould_UserDetailView = true
                                        }){
                                            Text("アカウント表示")
                                        }
                                        Button(action: {
                                            DisLikeUserUIDList.append(LikeUserUIDList[index])
                                            LikeUserUIDList.removeAll { $0 == LikeUser[index].UID }
                                            LikeUser.remove(at: index)
                                            UpdateLikeDisLikeUser()
                                        }){
                                            Text("削除")
                                        }
                                    }
                            }
                        } else {
                            ForEach(0..<MatchUser.count, id: \.self) { index in
                                ZStack {
                                    Image(uiImage: MatchUser[index].UserImage).resizable().frame(width: 230, height: 300).cornerRadius(10)
                                    VStack{
                                        Spacer()
                                        Text(MatchUser[index].Username).frame(width: 230, height: 50).background(Color.white.opacity(0.6)).font(.title).fontWeight(.black).foregroundColor(Color.black)
                                    }
                                }.frame(width: 230, height: 300).cornerRadius(10)
                                    .onTapGesture {
                                        TapUserUID = MatchUser[index].UID
                                        Showshould_UserDetailView = true
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            Showshould_UserDetailView = true
                                        }){
                                            Text("アカウント表示")
                                        }
                                    }
                            }
                        }
                    }
                }
                .navigationTitle(Text(SelectedIndex == 0 ? "\(LikeUser.count)「👍Like!」" : "\(MatchUser.count)「❤️Match!」"))
                .navigationBarTitleDisplayMode(.large)
                Spacer()
            }
        }
        .onAppear{
            LikeUser.removeAll()
            MatchUser.removeAll()
            FetchLikeUser()
            FetchDisLikeUser()
            FetchMatchUser()
        }
        .sheet(isPresented: $Showshould_UserDetailView) { [TapUserUID] in
            UserDetailView(UserUID: TapUserUID, SelectedIndex: SelectedIndex)
        }
    }
    //LikeUser DisLikeUser
    private func FetchLikeUser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["LikeUser"] as? [String] {
                    LikeUserUIDList = fieldValue
                    for i in 0..<fieldValue.count{
                        FetchLikeUsername_Image(UID: LikeUserUIDList[i])
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    private func FetchDisLikeUser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["DisLikeUser"] as? [String] {
                    DisLikeUserUIDList = fieldValue
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    private func FetchLikeUsername_Image(UID: String){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let username = data!["Username"] as? String,
                   let useruid = data!["UID"] as? String {
                    let fic = FetchImageClass()
                    fic.FetchUserImage(username: username) { image in
                        LikeUser.append(LikeCardUserModel(UID: useruid, Username: username, UserImage: (image ?? UIImage(systemName: "photo"))!))
                    }
                }
                else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    
    private func UpdateLikeDisLikeUser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).updateData([
            "LikeUser": LikeUserUIDList,
            "DisLikeUser": DisLikeUserUIDList
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //MatchUser
    private func FetchMatchUser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["MatchUser"] as? [String] {
                    MatchUserUIDList = fieldValue
                    for i in 0..<fieldValue.count{
                        FetchMatchUsername_Image(UID: MatchUserUIDList[i])
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    private func FetchMatchUsername_Image(UID: String){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let username = data!["Username"] as? String,
                   let useruid = data!["UID"] as? String {
                    let fic = FetchImageClass()
                    fic.FetchUserImage(username: username) { image in
                        MatchUser.append(MatchCardUserModel(UID: useruid, Username: username, UserImage: (image ?? UIImage(systemName: "photo"))!))
                    }
                }
                else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    private func UpdateMatchUser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).updateData([
            "MatchUser": MatchUserUIDList
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

#Preview{
    LikedMatchedView(UserUID: "")
}
