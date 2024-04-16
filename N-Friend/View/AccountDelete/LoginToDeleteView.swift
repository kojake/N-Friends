//
//  LoginToDeleteView.swift
//  N-Friend
//
//  Created by kaito on 2024/04/16.
//

import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct LoginToDeleteView: View {
    @State var UserUID: String
    @State var Username: String
    
    @State private var isLoading = false
    
    @State private var Showshould_LoginView = false
    
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
            login(credential: credential)
        }
    }
    
    private func login(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("SignInError: \(error.localizedDescription)")
                return
            } else {
                AccountDelete()
            }
        }
    }
    
    var body: some View {
        VStack{
            NavigationLink(destination: LoginView(), isActive: $Showshould_LoginView) {
                EmptyView()
            }
            if isLoading{
                Progressview()
            }
        }.navigationBarBackButtonHidden(true)
        .onAppear{
            googleAuth()
        }
    }
    
    private func DeleteUserImage(){
        let storage = Storage.storage()
        
        let desertRef = storage.reference(forURL: "gs://n-friends.appspot.com").child(Username)
        
        desertRef.delete { error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                print("Image Delete sucsess")
            }
        }
    }
    
    private func AccountDelete() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
            } else {
                let db = Firestore.firestore()
                
                db.collection("UserList").document(UserUID).delete { error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    } else {
                        DeleteUserImage()
                        isLoading = false
                        Showshould_LoginView = true
                    }
                }
            }
        }
    }
}

#Preview {
    LoginToDeleteView(UserUID: "", Username: "")
}
