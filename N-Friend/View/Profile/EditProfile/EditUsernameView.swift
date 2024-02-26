//
//  EditUsernameView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/26.
//

import SwiftUI

struct EditUsernameView: View {
    @State var Username: String = "aaaaa"
    
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
    }
}

#Preview {
    EditUsernameView()
}
