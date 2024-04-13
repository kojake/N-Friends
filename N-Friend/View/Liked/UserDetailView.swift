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
    @State var UserProfile: UserModel = UserModel(UID: "???", UserImage: UIImage(systemName: "photo")!, Username: "???", EnrollmentCampus: "???", Tastes: ["???"])
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Image(uiImage: UserProfile.UserImage!).resizable().frame(width: 100, height: 100).cornerRadius(75).overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.black, lineWidth: 2)).padding()
                    VStack(alignment: .leading ){
                        Text(UserProfile.Username).font(.title).fontWeight(.semibold)
                        Text("@\(UserProfile.UID)").font(.system(size: 13))
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
                        }
                    }
                }
            }
            if isLoading{
                Progressview()
            }
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
                   let enrollmentcampus = data!["EnrollmentCampus"] as? String,
                   let tastes = data!["Tastes"] as? [String] {
                    FetchUserImage(username: username) { image in
                        UserProfile = UserModel(UID: useruid, UserImage: (image ?? UIImage(systemName: "photo"))!, Username: username, EnrollmentCampus: enrollmentcampus, Tastes: tastes)
                        isLoading = false
                    }
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    private func FetchUserImage(username: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: "gs://n-friends.appspot.com").child(username)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data, let uiImage = UIImage(data: data) {
                completion(uiImage)
            } else {
                completion(nil)
            }
        }
    }
}

#Preview {
    UserDetailView(UserUID: "")
}
