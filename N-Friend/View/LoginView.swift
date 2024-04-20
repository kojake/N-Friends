//
//  LoginView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    @State var UserUID: String = ""

    @State private var UserImage: UIImage?
    @State private var Showshould_ContentView = false
    @State private var Showshould_CreatedAccountDetailsEditView = false
    
    @State private var isLoading: Bool = false
    
    //GoogleAuthを使ってログインする
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
            isLoading = true
            self.login(credential: credential)
        }
    }
    
    private func login(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("SignInError: \(error.localizedDescription)")
                return
            }
            
            if let user = authResult?.user {
                //ユーザーが既に登録されているかを取得する
                let isNewUser = authResult?.additionalUserInfo?.isNewUser ?? true
                UserUID = user.uid
                //いない場合はユーザー情報をデータベースにアップロードする
                if isNewUser {
                    UserDefaults.standard.set(UserUID, forKey: "UserUID_Key")
                    UploadUserData()
                    isLoading = false
                    Showshould_CreatedAccountDetailsEditView = true
                } else {
                    isLoading = false
                    Showshould_ContentView = true
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                NavigationLink(destination: ContentView(UserUID: UserUID), isActive: $Showshould_ContentView){
                    EmptyView()
                }
                NavigationLink(destination: CreatedAccountDetailsEditView(UserUID: UserUID), isActive: $Showshould_CreatedAccountDetailsEditView){
                    EmptyView()
                }

                Color.blue.opacity(0.7).ignoresSafeArea()
                VStack{
                    Text("N-Friends").font(.largeTitle).fontWeight(.black).foregroundColor(Color.white).padding()
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
                }
                if isLoading{
                    Progressview()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    private func UploadUserData(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).setData([
            "Username": UserUID,
            "UID": UserUID,
            "SlackID": "",
            "EnrollmentCampus": "秋葉原",
            "Tastes": [String](),
            "LikeUser": [String](),
            "DisLikeUser": [String](),
            "MatchUser": [String](),
            "Notification": [String]()
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
