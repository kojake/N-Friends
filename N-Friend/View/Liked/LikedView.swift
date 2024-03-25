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
    
    @State var UserUID: String
    
    @State var LikeUserUIDList: [String] = []
    @State var LikeUser: [LikeCardUserModel] = []
    @State private var Showshould_UserDetailView = false
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    ForEach(0..<LikeUser.count, id: \.self) { index in
                        VStack {
                            Image(uiImage: LikeUser[index].UserImage).resizable().scaledToFit().frame(width: 180, height: 250).cornerRadius(10)
                            Text(LikeUser[index].Username).font(.title3).fontWeight(.black).foregroundColor(Color.black)
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
            LikeUser.removeAll()
            FetchLikeUser()
            //存在するLikeUser分UIDを関数に渡す
            for i in 0..<LikeUserUIDList.count{
                FetchLikeUsername_Image(UID: LikeUserUIDList[i], index: i)
            }
        }
        .sheet(isPresented: $Showshould_UserDetailView){
            UserDetailView(UserUID: UserUID)
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
                if let username = data!["Username"] as? String{
                    FetchUserImage(username: username) { image in
                        LikeUser.append(LikeCardUserModel(Username: username, UserImage: (image ?? UIImage(named: "Person1"))!))
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
