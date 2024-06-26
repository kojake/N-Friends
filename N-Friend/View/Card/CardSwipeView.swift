//
//  FindingFriendsView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import AudioToolbox
import FirebaseFirestore
import FirebaseStorage

struct CardSwipeView: View {
    var UserUID: String
    @State var Username: String = ""
    
    @State var CardUserList: [CardUserModel] = []
    @State var CardState: String = ""
    
    @State var LikeUser: [String] = []
    @State var DisLikeUser: [String] = []
    
    @State var MatchUser: [String] = []
    @State var LastMatchUsername: String = ""
    
    @State var Notification: [String] = []
    
    @State private var Showshould_NotificationView = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                NavigationLink(destination: NotificationView(UserUID: UserUID), isActive: $Showshould_NotificationView) {
                    EmptyView()
                }
                ZStack{
                    VStack{
                        HStack{
                            Spacer()
                            Text("N-Friends").font(.largeTitle).fontWeight(.black)
                            Spacer()
                            Button(action: {
                                Showshould_NotificationView = true
                            }){
                                Image(systemName: "bell.fill").resizable().scaledToFit().frame(width: 25, height: 25).foregroundColor(Color.yellow)
                            }.padding()
                        }.padding()
                        Spacer()
                        ZStack{
                            ForEach(CardUserList) { model in
                                ZStack{
                                    Image(uiImage: model.UserImage).resizable().frame(height: geo.size.height - 200).background(Color.white).cornerRadius(20).padding(.horizontal, 15)
                                    VStack{
                                        HStack{
                                            let cardindex = CardUserList.indices.last
                                            if CardState == "Like" && model.Username == CardUserList[cardindex!].Username {
                                                Text("LIKE").font(.system(size: 45)).fontWeight(.black).foregroundColor(Color.green).padding()
                                                Spacer()
                                            } else if CardState == "DisLike" && model.Username == CardUserList[cardindex!].Username {
                                                Spacer()
                                                Text("DISLIKE").font(.system(size: 45)).fontWeight(.black).foregroundColor(Color.red).padding()
                                            }
                                        }
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
                                    }.frame(width: geo.size.width - 32, height: geo.size.height - 190).background(Color.black.opacity(0.2)).foregroundColor(Color.white)
                                }.gesture(DragGesture()
                                    .onChanged({ (value) in
                                        if value.translation.width > 0 {
                                            if let cardindex = CardUserList.indices.last{
                                                CardUserList[cardindex].Swipe = value.translation.width
                                                CardUserList[cardindex].degrees = 8
                                                CardState = "Like"
                                            }
                                        } else {
                                            if let cardindex = CardUserList.indices.last{
                                                CardUserList[cardindex].Swipe = value.translation.width
                                                CardUserList[cardindex].degrees = -8
                                                CardState = "DisLike"
                                            }
                                        }
                                    }).onEnded({ (value) in
                                        if model.Swipe > 0 {
                                            if model.Swipe > geo.size.width / 2 - 80{
                                                if let cardindex = CardUserList.indices.last{
                                                    CardUserList[cardindex].Swipe = 700
                                                    CardUserList[cardindex].degrees = 8
                                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                    LikeUserMatchCheck(LikedUserUID: CardUserList[cardindex].UserUID, LikedUsername: CardUserList[cardindex].Username)
                                                    LikeUser.append(CardUserList[cardindex].UserUID)
                                                    UpdateLikeUser()
                                                    CardUserList.remove(at: cardindex)
                                                    CardState = ""
                                                }
                                            } else {
                                                if let cardindex = CardUserList.indices.last{
                                                    CardUserList[cardindex].Swipe = 0
                                                    CardUserList[cardindex].degrees = 0
                                                    CardState = ""
                                                }
                                            }
                                        } else {
                                            if -model.Swipe > geo.size.width / 2 - 80{
                                                if let cardindex = CardUserList.indices.last{
                                                    CardUserList[cardindex].Swipe = -700
                                                    CardUserList[cardindex].degrees = 8
                                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                    DisLikeUser.append(CardUserList[cardindex].UserUID)
                                                    UpdateDisLikeUser()
                                                    CardUserList.remove(at: cardindex)
                                                    CardState = ""
                                                }
                                            } else {
                                                if let cardindex = CardUserList.indices.last{
                                                    CardUserList[cardindex].Swipe = 0
                                                    CardUserList[cardindex].degrees = 0
                                                    CardState = ""
                                                }
                                            }
                                        }
                                    })
                                ).frame(height: geo.size.height - 290).offset(x: model.Swipe)
                                    .rotationEffect(.init(degrees: model.degrees))
                                    .animation(.spring())
                            }
                        }
                        Spacer()
                        HStack{
                            Button(action: {
                                if let cardindex = CardUserList.indices.last{
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    LikeUser.append(CardUserList[cardindex].UserUID)
                                    UpdateLikeUser()
                                    LikeUserMatchCheck(LikedUserUID: CardUserList[cardindex].UserUID, LikedUsername: CardUserList[cardindex].Username)
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
        }
        .onAppear {
            isLoading = true
            CardUserList.removeAll()

            // 各データの読み込み処理を非同期で実行
            DispatchQueue.global(qos: .userInitiated).async {
                let group = DispatchGroup()

                group.enter()
                FetchUsername() {
                    group.leave()
                }

                group.enter()
                FetchLastMatchUsername() {
                    group.leave()
                }

                group.enter()
                FetchCardUserData() {
                    group.leave()
                }

                group.enter()
                FetchLikeuser() {
                    group.leave()
                }

                group.enter()
                FetchDisLikeuser() {
                    group.leave()
                }

                group.enter()
                FetchNotification() {
                    group.leave()
                }

                group.enter()
                FetchMatchUser() {
                    group.leave()
                }

                // 全ての非同期処理が完了した後でUIを更新
                group.notify(queue: .main) {
                    isLoading = false
                }
            }
        }
    }
    
    //ユーザーネームを取得する
    private func FetchUsername(completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let username = document.data()?["Username"] as? String {
                    DispatchQueue.main.async {
                        Username = username
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
            completion()
        }
    }

    
    //一枚一枚のカードデータを取得する
    private func FetchCardUserData(completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        db.collection("UserList").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion()
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                completion()
                return
            }

            for document in documents {
                let data = document.data()
                if let username = data["Username"] as? String,
                   let useruid = data["UID"] as? String,
                   let tastes = data["Tastes"] as? [String],
                   let enrollmentcampus = data["EnrollmentCampus"] as? String {
                    let fic = FetchImageClass()
                    fic.FetchUserImage(username: username) { image in
                        DispatchQueue.main.async {
                            if !LikeUser.contains(useruid) && !DisLikeUser.contains(useruid) && UserUID != useruid {
                                CardUserList.append(CardUserModel(UserUID: useruid, UserImage: (image ?? UIImage(systemName: "photo"))!, Username: username, EnrollmentCampus: enrollmentcampus, Tastes: tastes, Swipe: 0, degrees: 0)) 
                            }
                        }
                    }
                }
            }
            completion()
        }
    }
    
    //Like DisLike func
    //ユーザーのLikeしたユーザーリストを取得する
    private func FetchLikeuser(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["LikeUser"] as? [String] {
                    DispatchQueue.main.async {
                        LikeUser = fieldValue
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
            completion()
        }
    }

    
    //ユーザーのDisLikeしたユーザーのリストを取得する
    private func FetchDisLikeuser(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["DisLikeUser"] as? [String] {
                    DispatchQueue.main.async {
                        DisLikeUser = fieldValue
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
            completion()
        }
    }

    
    //ユーザーのLikeリストを更新する
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
    
    //ユーザーのDisLikeリストを更新する
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
    //Liekしたユーザーが自分のことをLikeしているかをチェックする
    private func LikeUserMatchCheck(LikedUserUID: String, LikedUsername: String){
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
                        
                        //通知リストにマッチしたことを追加する
                        Notification.append("\(LikedUsername)さんとマッチしました!")
                        UpdateNotification()
                        
                        //マッチしたユーザー側の通知リストに自分とマッチしたことを追加する
                        FetchMatchuserNotification(MatchUserUID: LikedUserUID)
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }

    //ユーザーのマッチリストを取得する
    private func FetchMatchUser(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let MatchUserList = document.data()?["MatchUser"] as? [String] {
                    DispatchQueue.main.async {
                        MatchUser = MatchUserList
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
            completion()
        }
    }

    
    //ユーザーのマッチリストを更新する
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
    
    //LikeしマッチしたユーザーのMatchリストを取得する
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
    
    //LikeしマッチしたユーザーのMatchリストを更新する
    private func UpdateMatchUserMatchList(LikedUserUID: String) {
        let db = Firestore.firestore()
        
        var MatchedUser_MatchList = [String]()
        
        FetchMatchUserMatchList(LikedUserUID: LikedUserUID) { matcheduser_matchlist   in
            MatchedUser_MatchList = matcheduser_matchlist!
        }
        MatchedUser_MatchList.append(UserUID)
        
        db.collection("UserList").document(LikedUserUID).updateData([
            "MatchUser": MatchedUser_MatchList,
            "LastMatchUsername": Username
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //Notification
    //ユーザーの通知リストを取得する
    private func FetchNotification(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let notification = document.data()?["Notification"] as? [String] {
                    DispatchQueue.main.async {
                        Notification = notification
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
            completion()
        }
    }

    
    //ユーザーの通知リストを更新する
    private func UpdateNotification() {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).updateData([
            "Notification": Notification
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //マッチしたユーザーの通知リストを取得する
    private func FetchMatchuserNotification(MatchUserUID: String) {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(MatchUserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if var notification = document.data()?["Notification"] as? [String] {
                    notification.append("\(Username)さんとマッチしました!")
                    UpdateMatchUserNotification(MatchUserUID: MatchUserUID, MatchUserNotification: notification)
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    //マッチしたユーザーの通知リストを更新する
    private func UpdateMatchUserNotification(MatchUserUID: String, MatchUserNotification: [String]) {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(MatchUserUID).updateData([
            "Notification": MatchUserNotification
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //Realtime
    
    //最後にマッチしたユーザーの名前を取得する
    private func FetchLastMatchUsername(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let lastmatchusername = document.data()?["LastMatchUsername"] as? String {
                    DispatchQueue.main.async {
                        LastMatchUsername = lastmatchusername
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
            completion()
        }
    }

    
    //最後にマッチしたユーザーの名前を更新する
    private func UpdateLastMatchUsername() {
        let db = Firestore.firestore()

        db.collection("UserList").document(UserUID).updateData([
            "LastMatchUsername": LastMatchUsername
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //リアルタイムでデータベースの変更をチェックする
    private func RealtimeCheckMatch() {
        let db = Firestore.firestore()

        db.collection("UserList").document(UserUID).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            if LastMatchUsername != data["LastMatchUsername"] as? String {
                makeNotification(MatchedUsername: data["LastMatchUsername"] as! String)
                LastMatchUsername = data["LastMatchUsername"] as! String
                UpdateLastMatchUsername()
            }
        }
    }
}
