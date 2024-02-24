//
//  ProfileView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).shadow(radius: 20).ignoresSafeArea()
            VStack{
                Image("Person1").resizable().scaledToFit().ignoresSafeArea()
                Spacer()
            }
            VStack{
                Spacer()
                VStack{
                    HStack{
                        Button(action: {
                            
                        }){
                            VStack{
                                ZStack{
                                    Image(systemName: "photo.badge.plus").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.black)
                                }.frame(width: 70, height: 70).background(Color.white).cornerRadius(50)
                                Text("ADD Photos").font(.title3).fontWeight(.black).foregroundColor(Color.white)
                            }.shadow(radius: 10)
                        }.padding()
                        Button(action: {
                            
                        }){
                            VStack{
                                ZStack{
                                    Image(systemName: "pencil").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.black)
                                }.frame(width: 70, height: 70).background(Color.white).cornerRadius(50)
                                Text("Edit Profile").font(.title3).fontWeight(.black).foregroundColor(Color.white)
                            }.shadow(radius: 10)
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: 400).background(Color.gray.opacity(0.4))
            }
        }
    }
}

#Preview {
    ProfileView()
}
