//
//  ProfileView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @State var Username: String = ""
    var Realname: String
    
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
                NavigationLink(destination: EditProfileView(Username: Username, Realname: Realname), isActive: $Showshould_EditProfileView){
                    EmptyView()
                }
                Spacer()
                VStack{
                    ZStack{
                        HStack(spacing: 0){
                            Rectangle().frame(width: 200, height: 1).foregroundColor(.clear)
                            VStack{
                                Rectangle().frame(width: 1, height: 10).foregroundColor(.clear)
                                Text(Realname).fontWeight(.bold).frame(width: 150, height: 40).background(Color.white).cornerRadius(30)
                            }
                        }
                        HStack(spacing: 0){
                            Text(Username).font(.title).fontWeight(.bold).frame(width: 200, height: 60).background(Color.blue).foregroundColor(Color.white).cornerRadius(8)
                            Rectangle().frame(width: 100, height: 1).foregroundColor(.clear)
                        }
                    }
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
        .onAppear{
            UsernameGet()
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
    private func UsernameGet(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(Realname).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["Username"] as? String {
                    Username = fieldValue
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
}
