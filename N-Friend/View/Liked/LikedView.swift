//
//  StarView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct LikedView: View {
    @State private var isLoading = false
    
    @State var TapUserUID: String = ""
    @State var UserUID: String
    
    @State var LikeUserUIDList: [String] = []
    @State var LikeUser: [LikeCardUserModel] = []
    @State private var Showshould_UserDetailView = false
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
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
            LikeUser.removeAll()
            FetchLikeUser()
            //存在するLikeUser分UIDを関数に渡す
            for i in 0..<LikeUserUIDList.count{
                FetchLikeUsername_Image(UID: LikeUserUIDList[i], index: i)
            }
        }
        .sheet(isPresented: $Showshould_UserDetailView){
            UserDetailView(UserUID: $TapUserUID)
        }
    }
    private func FetchLikeUser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["LikeUser"] as? [String] {
                    LikeUserUIDList = fieldValue
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    private func FetchLikeUsername_Image(UID: String, index: Int){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let username = data!["Username"] as? String,
                   let useruid = data!["UID"] as? String {
                    FetchUserImage(username: username) { image in
                        LikeUser.append(LikeCardUserModel(UID: useruid, Username: username, UserImage: (image ?? UIImage(named: "Person1"))!))
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
    private func FetchUserImage(username: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: "gs://n-friends.appspot.com").child(username)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data, let uiImage = UIImage(data: data) {
                completion(uiImage)
            } else {
                completion(nil)
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
