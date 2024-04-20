//
//  NotificationView.swift
//  N-Friend
//
//  Created by kaito on 2024/04/20.
//

import SwiftUI
import FirebaseFirestore

struct NotificationView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    var UserUID: String
    @State var Notification: [String] = []
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "chevron.left").resizable().scaledToFit().frame(width: 30, height: 30)
                }.padding()
                Text("お知らせ").font(.system(size: 30)).fontWeight(.bold)
                Spacer()
            }.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            ScrollView{
                ForEach(0..<Notification.count, id: \.self) { index in
                    VStack(alignment: .leading){
                        Text(Notification[index]).font(.title3).fontWeight(.semibold)
                        Divider()
                    }.padding()
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            FetchNotification()
        }
    }
    private func FetchNotification() {
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let notification = document.data()?["Notification"] as? [String] {
                    Notification = notification
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
}

#Preview {
    NotificationView(UserUID: "")
}
