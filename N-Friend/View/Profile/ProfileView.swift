//
//  ProfileView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct ProfileView: View {
    @State var Username: String = "Username"
    
    @State private var Showshould_EditProfileView = false
    
    //Signout
    @State private var Signoutalert = false
    @State private var Showshould_LoginView = false
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).shadow(radius: 20).ignoresSafeArea()
            VStack{
                Image("Person1").resizable().scaledToFit().ignoresSafeArea()
                Spacer()
            }
            VStack{
                NavigationLink(destination: EditProfileView(), isActive: $Showshould_EditProfileView){
                    EmptyView()
                }
                Spacer()
                VStack{
                    Text(Username).font(.title).fontWeight(.bold).frame(width: 200, height: 60).background(Color.white)
                    Spacer()
                    HStack{
                        Button(action: {
                            
                        }){
                            VStack{
                                ZStack{
                                    Image(systemName: "photo.badge.plus").resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(Color.black)
                                }.frame(width: 70, height: 70).background(Color.white).cornerRadius(50)
                                Text("ADD Photos").font(.title3).fontWeight(.black).foregroundColor(Color.white)
                            }.shadow(radius: 10)
                        }
                        Button(action: {
                            Showshould_EditProfileView = true
                        }){
                            VStack{
                                ZStack{
                                    Image(systemName: "pencil").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.black)
                                }.frame(width: 70, height: 70).background(Color.white).cornerRadius(50)
                                Text("Edit Profile").font(.title3).fontWeight(.black).foregroundColor(Color.white)
                            }.shadow(radius: 10)
                        }.padding()
                        Button(action: {
                            Signoutalert = true
                        }){
                            VStack{
                                ZStack{
                                    Image(systemName: "person.crop.circle.fill.badge.xmark").resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(Color.white)
                                }.frame(width: 70, height: 70).background(Color.red).cornerRadius(50)
                                Text("Sign out").font(.title3).fontWeight(.black).foregroundColor(Color.white)
                            }.shadow(radius: 10)
                        }
                    }
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: 400).background(Color.gray.opacity(0.4))
            }
        }
        .alert(isPresented: $Signoutalert) {
            Alert(title: Text("確認"),
                  message: Text("本当にサインアウトしますか？"),
                  primaryButton: .cancel(Text("キャンセル")),
                  secondaryButton: .default(Text("サインアウト"),
                                          action: {
                Showshould_LoginView = true
            }))
        }
        .navigationDestination(isPresented: $Showshould_LoginView) {
            LoginView()
        }
    }
}

#Preview {
    ProfileView()
}
