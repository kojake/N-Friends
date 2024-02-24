//
//  CardView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        ZStack{
            Image("Person1").resizable()
            VStack{
                Spacer()
                HStack{
                    VStack(alignment: .leading){
                        Text("Username").font(.title2).fontWeight(.black)
                        Text("興味/趣味")
                        Spacer()
                        
                        Spacer()
                    }.padding()
                    Spacer()
                }.frame(width: 300, height: 120).background(Color.blue.opacity(0.5))
            }
        }.frame(width: 300, height: 450).background(Color.gray).cornerRadius(20).shadow(radius: 10)
    }
}

#Preview {
    CardView()
}
