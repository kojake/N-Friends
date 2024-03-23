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
        ZStack{
            ScrollView{
                ForEach(0..<LikeUser.count, id: \.self) { index in
                    VStack {
                        Image("Person1").resizable().scaledToFit().frame(width: 180, height: 250).cornerRadius(10)
                        Text(LikeUser[index]).font(.title).fontWeight(.black).foregroundColor(Color.black)
                        Spacer()
                    }.frame(width: 230, height: 300).background(Color.blue.opacity(0.3)).cornerRadius(10)
                        .onTapGesture {
                            Showshould_UserDetailView = true
                        }
                        .onLongPressGesture{
                            
                        }
                }
            }
            VStack{
                HStack{
                    HStack{
                        Text("\(LikeUser.count)").font(.title2).fontWeight(.black)
                        Text("「Like!」").font(.title2).fontWeight(.black)
                    }.padding()
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: 50).background(Color.gray.opacity(0.5))
                Spacer()
            }
            .onAppear{
                FetchLikedUser()
            }
        }
        .sheet(isPresented: $Showshould_UserDetailView){
            UserDetailView()
        }
    }
    private func FetchLikedUser(){
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
}
