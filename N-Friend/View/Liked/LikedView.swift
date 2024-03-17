//
//  StarView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore

struct LikedView: View {
    @State var LikedUserList: [String] = []
    
    var body: some View {
        ZStack{
            ScrollView{
                ForEach(0..<LikedUserList.count, id: \.self) { index in
                    Button(action: {
                        
                    }) {
                        VStack {
                            Image("Person1").resizable().scaledToFit().frame(width: 180, height: 250).cornerRadius(10)
                            Text(LikedUserList[index]).font(.title).fontWeight(.black).foregroundColor(Color.black)
                            Spacer()
                        }.frame(width: 230, height: 300).background(Color.blue.opacity(0.3)).cornerRadius(10)
                    }
                }
            }
            VStack{
                HStack{
                    HStack{
                        Text("\(LikedUserList.count)").font(.title2).fontWeight(.black)
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
    }
    private func FetchLikedUser(){
        let db = Firestore.firestore()
        
        db.collection("LikedUser").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                LikedUserList = documents.map { $0.documentID }
            }
        }
    }
}

#Preview {
    LikedView()
}
