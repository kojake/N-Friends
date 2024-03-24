//
//  FindingFriendsView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct CardSwipeView: View {
    var UserUID: String
    
    @State var CardUserList: [UserModel] = []
    @State var LikeUser: [String] = []
    @State var DisLikeUser: [String] = []
    
    @State private var isLoading = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                VStack{
                    HStack{
                        Spacer()
                        Text("N-Friends").font(.largeTitle).fontWeight(.black)
                        Spacer()
                    }
                    Spacer()
                    ZStack{
                        ForEach(CardUserList) { model in
                            if !LikeUser.contains(model.UserUID) && !DisLikeUser.contains(model.UserUID){
                                ZStack{
                                    Image(uiImage: model.UserImage).resizable().frame(height: geo.size.height - 200).cornerRadius(20).padding(.horizontal, 15)
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
                                                    CardUserList[cardindex].Swipe = 700
                                                    CardUserList[cardindex].degrees = 8
                                                    
                                                    LikeUser.append(CardUserList[cardindex].UserUID)
                                                    UpdateLikeUser()
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
                                                    
                                                    DisLikeUser.append(CardUserList[cardindex].UserUID)
                                                    UpdateDisLikeUser()
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
                                DisLikeUser.append(CardUserList[cardindex].UserUID)
                                UpdateDisLikeUser()
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
                                LikeUser.append(CardUserList[cardindex].UserUID)
                                UpdateLikeUser()
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
            if isLoading{
                Progressview(Progressmessage: "読み込み中")
            }
        }
        .onAppear{
            isLoading = true
            FetchCardUserData()
            FetchLikeuser()
            FetchDisLikeuser()
        }
    }
    private func FetchCardUserData(){
        let db = Firestore.firestore()
        
        // 指定したコレクションの参照を取得
        let collectionRef = db.collection("UserList")
        
        // コレクション内のすべてのドキュメントを取得
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            for document in documents {
                // 各ドキュメントから複数のフィールドの値を取得
                let data = document.data()
                if let username = data["Username"] as? String,
                   let useruid = data["UID"] as? String,
                   let enrollmentcampus = data["EnrollmentCampus"] as? String,
                   let tastes = data["Tastes"] as? [String] {
                    FetchCardUserImage(username: username) { image in
                        CardUserList.append(UserModel(UserImage: (image ?? UIImage(named: "Person1"))! ,Username: username, UserUID: useruid, EnrollmentCampus: enrollmentcampus, Tastes: tastes, Swipe: 0, degrees: 0))
                    }
                }
            }
            
            isLoading = false
        }
    }
    private func FetchCardUserImage(username: String, completion: @escaping (UIImage?) -> Void) {
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
    
    //Like DisLike func
    private func FetchLikeuser(){
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
    private func FetchDisLikeuser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["DisLikeUser"] as? [String] {
                    DisLikeUser = fieldValue
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
    private func UpdateDisLikeUser(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).updateData([
            "DisLikeUser": DisLikeUser
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
