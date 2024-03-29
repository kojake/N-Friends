//
//  ProfileView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    //Profile
    @State var UserUID: String
    @State var UserProfile: UserModel = UserModel(UID: "???", UserImage: UIImage(named: "Person1")!, Username: "???", EnrollmentCampus: "???", Tastes: ["???"])
    @State var CampusSelectionIndexValue: Int = 0
    @State var Previousname: String = ""
    
    @State private var isLoading: Bool = false
    
    @State private var Showshould_TastesEditView = false
    
    //Picker
    @State var AllCampus: [String] = ["秋葉原", "代々木", "新宿"]
    
    @State private var Showshould_ImagePickerView = false
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    HStack{
                        ZStack{
                            if let userimage = UserProfile.UserImage {
                                Image(uiImage: userimage)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(75)
                                    .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.black, lineWidth: 2))
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color.blue)
                            }
                            HStack{
                                Rectangle().frame(width: 50, height: 1).foregroundColor(.clear)
                                VStack{
                                    Rectangle().frame(width: 1, height: 50).foregroundColor(.clear)
                                    Button(action: {
                                        Showshould_ImagePickerView = true
                                    }){
                                        ZStack{
                                            Image(systemName: "plus").foregroundColor(Color.white)
                                        }.frame(width: 30, height: 30).background(Color.blue).cornerRadius(50)
                                    }
                                }
                            }
                        }
                        VStack(alignment: .leading ){
                            Text(UserProfile.Username).font(.title).fontWeight(.semibold)
                            Text("@\(UserProfile.UID)").font(.system(size: 13))
                        }
                    }.padding()
                    Spacer()
                }
                
                Form{
                    Section{
                        HStack {
                            VStack{
                                Image(systemName: "person.text.rectangle").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.blue)
                            }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                            Text("名前")
                                .fontWeight(.semibold)
                            TextField(UserProfile.Username, text: $UserProfile.Username)
                                .onChange(of: UserProfile.Username) { _ in
                                    UpdateUserProfile()
                                }
                        }
                        HStack{
                            VStack{
                                Image(systemName: "mappin.and.ellipse").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.green)
                            }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                            Picker("所属キャンパス", selection: $CampusSelectionIndexValue) {
                                ForEach(0..<AllCampus.count, id: \.self){ index in
                                    Text(AllCampus[index]).tag(index)
                                }
                            }.fontWeight(.semibold)
                                .onChange(of: CampusSelectionIndexValue) { NewValue in
                                    UpdateUserProfile()
                                }
                        }
                        HStack {
                            VStack{
                                Image(systemName: "gamecontroller").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.pink)
                            }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                            Text("趣味")
                                .fontWeight(.semibold)
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(0..<UserProfile.Tastes.count, id: \.self) { index in
                                        Text(UserProfile.Tastes[index]).fontWeight(.semibold).frame(width: 130, height: 30).background(Color.blue).foregroundColor(Color.white).cornerRadius(5)
                                    }
                                }
                            }
                        }.onTapGesture {
                            Showshould_TastesEditView = true
                        }
                    }
                }
            }
            if isLoading{
                Progressview()
            }
        }
        .toolbar{
            ToolbarItem(placement: .keyboard) {
                Button("閉じる") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .onAppear{
            isLoading = true
            FetchUserProfile()
        }
        .onDisappear{
            DeleteUserImage()
            UpdateUserImage()
        }
        .sheet(isPresented: $Showshould_TastesEditView){
            TastesEditView(UserUID: UserProfile.UID, UserTastesList: $UserProfile.Tastes)
            
        }
        .sheet(isPresented: $Showshould_ImagePickerView) {
            ImagePicker(UserImage: $UserProfile.UserImage, Showshould_ImagePickerView: $Showshould_ImagePickerView)
                .onDisappear {
                    DeleteUserImage()
                    UpdateUserImage()
                }
        }
    }
    // Profile
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
                        UserProfile = UserModel(UID: useruid, UserImage: (image ?? UIImage(named: "Person1"))!, Username: username, EnrollmentCampus: enrollmentcampus, Tastes: tastes)
                        isLoading = false
                    }
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    private func UpdateUserProfile(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(UserProfile.UID).updateData([
            "Username": UserProfile.Username,
            "EnrollmentCampus": AllCampus[CampusSelectionIndexValue]
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //UserImage
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
    private func UpdateUserImage() {
        let image = UserProfile.UserImage
        
        let storageref = Storage.storage().reference(forURL: "gs://n-friends.appspot.com").child(UserProfile.Username)
        
        //UserImageがnilの状態をチェックし、nilでない場合にデータ変換をする処理を実装
        guard let data = image!.jpegData(compressionQuality: 1.0) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        storageref.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image successfully updated")
            }
        }
    }
    private func DeleteUserImage(){
        let storage = Storage.storage()
        
        let desertRef = storage.reference(forURL: "gs://n-friends.appspot.com").child(Previousname)
        
        desertRef.delete { error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                print("Image success deleted")
                Previousname = UserProfile.Username
            }
        }
    }
}

#Preview {
    ProfileView(UserUID: "")
}
