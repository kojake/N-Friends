//
//  CreatedAccountDetailsEditView.swift
//  N-Friend
//
//  Created by kaito on 2024/03/26.
//

import SwiftUI

struct CreatedAccountDetailsEditView: View {
    
    var body: some View {
        VStack{
            HStack{
                Text("アカウントを自分なりに\n編集しましょう!").font(.title2).fontWeight(.black).padding()
                Spacer()
                Image(systemName: "pencil").resizable().scaledToFit().frame(width: 50, height:500).padding()
            }
            
            Spacer()
        }
    }
}

#Preview {
    CreatedAccountDetailsEditView()
}
