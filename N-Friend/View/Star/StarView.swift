//
//  StarView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct StarView: View {
    var body: some View {
        ZStack{
            ScrollView{
                ForEach(0..<5) { _ in
                    HStack{
                        ForEach(0..<2) { _ in
                            Button(action: {
                                
                            }){
                                Image("Person1").resizable().scaledToFit().frame(width: 180, height: 300).shadow(radius: 10).cornerRadius(40)
                            }
                        }
                    }
                }
            }
            VStack{
                HStack{
                    HStack{
                        Text("10").font(.title2).fontWeight(.black)
                        Text("「いいね！」").font(.title2).fontWeight(.black)
                    }.padding()
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: 50).background(Color.gray.opacity(0.5))
                Spacer()
            }
        }
    }
}

#Preview {
    StarView()
}
