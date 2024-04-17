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
    
    @State var CardUserList: [CardUserModel] = []
    @State var LikeUser: [String] = []
    @State var DisLikeUser: [String] = []
    @State var MatchUser: [String] = []
    
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
                            ZStack{
                                Image(uiImage: model.UserImage).resizable().frame(height: geo.size.height - 200).background(Color.white).cornerRadius(20).padding(.horizontal, 15)
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
                                                LikeUserMatchconfirmation(LikedUserUID: CardUserList[cardindex].UserUID, LikedUsername: CardUserList[cardindex].Username)
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
                                LikeUserMatchconfirmation(LikedUserUID: CardUserList[cardindex].UserUID, LikedUsername: CardUserList[cardindex].Username)
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
                Progressview()
            }
        }
        .onAppear{
            isLoading = true
            CardUserList.removeAll()
            FetchCardUserData()
            FetchLikeuser()
            FetchDisLikeuser()
            FetchMatchUser()
        }
    }
    private func FetchCardUserData(){
        let db = Firestore.firestore()
        
        db.collection("UserList").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            for document in documents {
                let data = document.data()
                if let username = data["Username"] as? String,
                   let useruid = data["UID"] as? String,
                   let enrollmentcampus = data["EnrollmentCampus"] as? String,
                   let tastes = data["Tastes"] as? [String] {
                    FetchCardUserImage(username: username) { image in
                        if !LikeUser.contains(useruid) && !DisLikeUser.contains(useruid) && UserUID != useruid{
                            CardUserList.append(CardUserModel(UserUID: useruid, UserImage: (image ?? UIImage(systemName: "photo"))! ,Username: username, EnrollmentCampus: enrollmentcampus, Tastes: tastes, Swipe: 0, degrees: 0))
                        }
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
    
    //Match
    private func LikeUserMatchconfirmation(LikedUserUID: String, LikedUsername: String){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(LikedUserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let LikedUser_LikeList = document.data()?["LikeUser"] as? [String] {
                    //ライクしたユーザーが自分をライクしているかを確認
                    if LikedUser_LikeList.contains(UserUID) {
                        MatchUser.append(LikedUserUID)
                        UpdateMatchUser()
                        
                        //マッチしたことを通知(自身)
                        makeNotification(MatchedUsername: LikedUsername)
                        
                        //マッチしたユーザーのマッチリストに自分のUIDを追加する
                        UpdateMatchUserMatchList(LikedUserUID: LikedUserUID)
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }

    private func FetchMatchUser() {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let MatchUserList = document.data()?["MatchUser"] as? [String] {
                    MatchUser = MatchUserList
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    private func UpdateMatchUser() {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).updateData([
            "MatchUser": MatchUser
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    private func FetchMatchUserMatchList(LikedUserUID: String, completion: @escaping ([String]?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(LikedUserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let MatchedUser_MatchList = document.data()?["MatchUser"] as? [String] {
                    completion(MatchedUser_MatchList)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    private func UpdateMatchUserMatchList(LikedUserUID: String) {
        let db = Firestore.firestore()
        
        var MatchedUser_MatchList = [String]()
        
        FetchMatchUserMatchList(LikedUserUID: LikedUserUID) { matcheduser_matchlist   in
            MatchedUser_MatchList = matcheduser_matchlist!
        }
        MatchedUser_MatchList.append(UserUID)
        
        db.collection("UserList").document(LikedUserUID).updateData([
            "MatchUser": MatchedUser_MatchList
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
