//
//  CreatedAccountDetailsEditView.swift
//  N-Friend
//
//  Created by kaito on 2024/03/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct CreatedAccountDetailsEditView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    //Profile
    @State var UserUID: String
    @State var UserProfile: UserModel = UserModel(UID: "", UserImage: UIImage(systemName: "photo")!, Username: "", EnrollmentCampus: "", Tastes: [String]())
    @State var CampusSelectionIndexValue: Int = 0
    @State var Previousname: String = ""
    
    @State private var isLoading: Bool = false
    @State private var AccountCreationLoading: Bool = false
    
    @State private var Showshould_TastesEditView = false
    @State private var Showshould_ContentView = false
    
    //Picker
    @State var AllCampus: [String] = ["秋葉原", "代々木", "新宿"]
    @State private var Showshould_ImagePickerView = false
    
    //Erroralert
    @State private var Erroralert = false
    @State private var Errormessage = ""
    
    var body: some View {
        ZStack{
            NavigationLink(destination: ContentView(UserUID: UserUID), isActive: $Showshould_ContentView){
                EmptyView()
            }
            VStack{
                HStack{
                    Image(systemName: "person.crop.circle.badge.questionmark").resizable().scaledToFit().frame(width: 35, height: 35)
                    Text("プロフィールを作成").font(.title2).fontWeight(.semibold)
                }
                HStack{
                    HStack{
                        ZStack{
                            if let userimage = UserProfile.UserImage {
                                Image(uiImage: userimage)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(75)
                                    .overlay(RoundedRectangle(cornerRadius: 75).stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2))
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
                            Text(UserProfile.Username).font(.title).fontWeight(.semibold).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            Text("@\(UserProfile.UID)").font(.system(size: 13)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }.padding()
                    Spacer()
                }
                ZStack{
                    Form{
                        Section{
                            HStack {
                                VStack{
                                    Image(systemName: "person.text.rectangle").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.blue)
                                }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                                Text("名前")
                                    .fontWeight(.semibold)
                                TextField("タップして入力", text: $UserProfile.Username)
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
                    VStack{
                        Spacer()
                        Button(action: {
                            if UserProfile.Username == ""{
                                Errormessage = "名前を入力してください"
                                Erroralert = true
                            } else if UserProfile.Tastes == []{
                                Errormessage = "趣味を選択してください"
                                Erroralert = true
                            } else {
                                AccountCreationLoading = true
                                UpdateUserProfile()
                                UpdateUserImage()
                            }
                        }){
                            HStack{
                                Text("これでOK!").font(.title2).fontWeight(.semibold)
                                Image(systemName: "checkmark").resizable().scaledToFit().frame(width: 20, height: 20)
                            }.frame(width: 180, height: 50).background(Color.green).foregroundColor(Color.white).cornerRadius(10)
                        }
                    }
                }
            }
            if AccountCreationLoading {
                AccountCreateProgressView()
            }
        }
        .onAppear{
            UserProfile =  UserModel(UID: UserUID, UserImage: UIImage(systemName: "photo")!, Username: "", EnrollmentCampus: "", Tastes: [String]())
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $Erroralert) {
            Alert(title: Text("エラー"), message: Text(Errormessage))
        }
        .toolbar{
            ToolbarItem(placement: .keyboard) {
                Button("閉じる") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .sheet(isPresented: $Showshould_TastesEditView){
            TastesEditView(UserUID: UserProfile.UID, UserTastesList: $UserProfile.Tastes)
            
        }
        .sheet(isPresented: $Showshould_ImagePickerView) {
            ImagePicker(UserImage: $UserProfile.UserImage, Showshould_ImagePickerView: $Showshould_ImagePickerView)
        }
    }
    // Profile
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
                AccountCreationLoading = false
                Showshould_ContentView = true
            }
        }
    }
    
    //UserImage
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
}

#Preview {
    CreatedAccountDetailsEditView(UserUID: "")
}
