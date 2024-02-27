//
//  LoginView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    @State var Realname: String = ""
    
    private func googleAuth() {
        
        guard let clientID:String = FirebaseApp.app()?.options.clientID else { return }
        let config:GIDConfiguration = GIDConfiguration(clientID: clientID)
        
        let windowScene:UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController:UIViewController? = windowScene?.windows.first!.rootViewController!
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController!) { result, error in
            guard error == nil else {
                print("GIDSignInError: \(error!.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
            self.login(credential: credential)
            Showshould_ContentView = true
        }
    }
    
    private func login(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("SignInError: \(error.localizedDescription)")
                return
            }
            
            // Firebaseにログイン成功したらユーザー情報を取得
            if let user = authResult?.user {
                // ユーザー名を取得
                Realname = user.displayName!
                CreateUserData()
            }
        }
    }
    
    @State private var Showshould_ContentView = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                NavigationLink(destination: ContentView(Realname: Realname), isActive: $Showshould_ContentView){
                    EmptyView()
                }
                Color.blue.opacity(0.7).ignoresSafeArea()
                VStack{
                    Text("N-Friends").font(.largeTitle).fontWeight(.black).padding()
                    Spacer()
                    Button(action: {
                        googleAuth()
                    }){
                        HStack{
                            Image("Google").resizable().scaledToFit().frame(width: 45, height: 45).padding()
                            Text("Googleでログインする").fontWeight(.bold).foregroundColor(Color.black)
                        }.frame(width: 280, height: 60).background(Color.white).cornerRadius(10)
                    }
                    Spacer()
                    Button(action: {
                        
                    }){
                        Text("ログインできませんか？").font(.title2).foregroundColor(Color.white)
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    private func CreateUserData(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(Realname).setData([
            "Username": Realname
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
}

#Preview {
    LoginView()
}
