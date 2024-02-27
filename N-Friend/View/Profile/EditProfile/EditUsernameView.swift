//
//  EditUsernameView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/26.
//

import SwiftUI
import FirebaseFirestore

struct EditUsernameView: View {
    var Realname: String
    @State var Username: String
    
    var body: some View {
        VStack(alignment: .trailing){
            Text("Username")
            TextField("\(Username)", text: $Username)
                .frame(width: 250, height: 50).background(Color.blue.opacity(0.3)).cornerRadius(8)
        }
        .toolbar{
            ToolbarItem(placement: .keyboard) {
                Button("閉じる") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .onDisappear{
            UsernameUpdate()
        }
    }
    private func UsernameUpdate(){
        let db = Firestore.firestore()
        
        // フィールドの値を更新
        db.collection("UserList").document(Realname).updateData([
            "Username": Username
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
