//
//  UserDetailView.swift
//  N-Friend
//
//  Created by kaito on 2024/03/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct UserDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isLoading = false
    
    var UserUID: String
    var SelectedIndex: Int
    
    @State var UserProfile: UserModel = UserModel(UID: "???", SlackID: "???" ,UserImage: UIImage(systemName: "photo")!, Username: "???", EnrollmentCampus: "???", Tastes: ["???"])
    
    @State private var Erroralert = false
    @State var Errormessage = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Image(uiImage: UserProfile.UserImage!).resizable().frame(width: 100, height: 100).cornerRadius(75).overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.black, lineWidth: 2)).padding()
                    VStack(alignment: .leading ){
                        Text(UserProfile.Username).font(.title).fontWeight(.semibold)
                    }
                    Spacer()
                }
                Spacer()
                NavigationView{
                    Form{
                        Section{
                            HStack {
                                VStack{
                                    Image(systemName: "person.text.rectangle").resizable().frame(width: 35, height: 35).foregroundColor(Color.blue)
                                }.frame(width: 50, height: 50).background(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.3)).cornerRadius(50)
                                Text(UserProfile.Username).font(.system(size: 15)).fontWeight(.semibold)
                            }
                            HStack{
                                VStack{
                                    Image(systemName: "mappin.and.ellipse").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.green)
                                }.frame(width: 50, height: 50).background(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.3)).cornerRadius(50)
                                Text("\(UserProfile.EnrollmentCampus)キャンパス").fontWeight(.semibold)
                            }
                            HStack {
                                VStack{
                                    Image(systemName: "gamecontroller").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.pink)
                                }.frame(width: 50, height: 50).background(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.3)).cornerRadius(50)
                                Text("趣味")
                                    .fontWeight(.semibold)
                                ScrollView(.horizontal){
                                    HStack{
                                        ForEach(0..<UserProfile.Tastes.count, id: \.self) { index in
                                            Text(UserProfile.Tastes[index]).fontWeight(.semibold).frame(width: 130, height: 30).background(Color.blue).foregroundColor(Color.white).cornerRadius(5)
                                        }
                                    }
                                }
                            }
                            if SelectedIndex == 1 {
                                Button(action: {
                                    if let url = URL(string: "https://n-jr.slack.com/team/\(UserProfile.SlackID)") {
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        } else {
                                            Errormessage = "URLが無効です。"
                                            Erroralert = true
                                        }
                                    }
                                }){
                                    HStack {
                                        VStack{
                                            Image(systemName: "number").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.black.opacity(0.8))
                                        }.frame(width: 50, height: 50).background(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.3)).cornerRadius(50)
                                        Text("SlackID")
                                            .fontWeight(.semibold)
                                        Text(UserProfile.SlackID)
                                        
                                    }
                                }.foregroundColor(Color.white)
                            }
                        }
                    }
                }
            }
            if isLoading{
                Progressview()
            }
        }
        .alert(isPresented: $Erroralert) {
            Alert(title: Text(Errormessage))
        }
        
        .onAppear{
            isLoading = true
            FetchUserProfile()
        }
    }
    private func FetchUserProfile(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserUID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let username = data!["Username"] as? String,
                   let useruid = data!["UID"] as? String,
                   let slackid = data!["SlackID"] as? String,
                   let enrollmentcampus = data!["EnrollmentCampus"] as? String,
                   let tastes = data!["Tastes"] as? [String] {
                    let fic = FetchImageClass()
                    fic.FetchUserImage(username: username) { image in
                        UserProfile = UserModel(UID: useruid, SlackID: slackid, UserImage: (image ?? UIImage(systemName: "photo"))!, Username: username, EnrollmentCampus: enrollmentcampus, Tastes: tastes)
                        isLoading = false
                    }
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
}

#Preview {
    UserDetailView(UserUID: "", SelectedIndex: 0)
}
