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
    @State var UserImage: UIImage?
    @State var Realname: String
    @State var Username: String = ""
    @State var Previousname: String = ""
    @State var CampusSelectionIndexValue: Int = 0
    
    //Progressview
    @State private var isLoading: Bool = false
    @State private var isDisappearLoading: Bool = false
    
    @State var UserTastesList: [String] = ["サッカー", "バスケ", "プログラミング"]
    @State private var Showshould_TastesEditView = false
    
    //Picker
    @State var AllCampus: [String] = ["秋葉原", "代々木", "新宿"]
    
    //Signout
    @State private var Signoutalert = false
    @State private var Showshould_LoginView = false
    
    //ImagePickerView
    @State private var Showshould_ImagePickerView = false
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    ZStack{
                        if let userimage = UserImage {
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
                    NavigationView{
                        Form{
                            Section{
                                HStack {
                                    VStack{
                                        Image(systemName: "person.text.rectangle").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color.blue)
                                    }.frame(width: 50, height: 50).background(Color.gray.opacity(0.3)).cornerRadius(50)
                                    Text("ユーザーネーム")
                                        .fontWeight(.semibold)
                                    TextField(Username, text: $Username)
                                        .onChange(of: Username) { _ in
                                            UpdateUsername()
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
                                            UpdateUserTastes()
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
                                            ForEach(0..<UserTastesList.count, id: \.self) { index in
                                                Text(UserTastesList[index]).fontWeight(.semibold).frame(width: 130, height: 30).background(Color.blue).foregroundColor(Color.white).cornerRadius(5)
                                            }
                                        }
                                    }
                                }.onTapGesture {
                                    Showshould_TastesEditView = true
                                }
                            }
                        }
                    }
                }
                if isLoading{
                    Progressview(Progressmessage: "ユーザー情報を取得中")
                }
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
            if !isDisappearLoading{
                isLoading = true
                FetchUsername()
                FetchEnrollmentCampus()
                FetchUserTastes()
            }
        }
        .onDisappear{
            if !isLoading{
                isDisappearLoading = true
                DeleteUserImage()
                UpdateUserImage()
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
        .sheet(isPresented: $Showshould_TastesEditView){
            TastesEditView(Realname: Realname, UserTastesList: $UserTastesList)
        }
        .sheet(isPresented: $Showshould_ImagePickerView){
            ImagePicker(UserImage: $UserImage, Showshould_ImagePickerView: $Showshould_ImagePickerView)
        }
    }
    //UserImage
    private func FetchUserImage(){
        let storageref = Storage.storage().reference(forURL: "gs://n-friends.appspot.com").child(Username)
        
        storageref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error{
                print("Error downloading image: \(error.localizedDescription)")
                isLoading = false
            } else if let data = data {
                UserImage = UIImage(data: data)
                //画像取得の関数が最後に実行されるので画像が取得できたらローディング画面を解除する
                isLoading = false
            }
        }
    }
    private func UpdateUserImage() {
        guard let image = UserImage else {
            print("No image to update.")
            return
        }

        let storageref = Storage.storage().reference(forURL: "gs://n-friends.appspot.com").child(Username)
        
        //UserImageがnilの状態をチェックし、nilでない場合にデータ変換をする処理を実装
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        storageref.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                isDisappearLoading = false
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
                Previousname = Username
            }
        }
    }
    
    //Username
    private func FetchUsername(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(Realname).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["Username"] as? String {
                    Username = fieldValue
                    Previousname = fieldValue
                    //同時に名前の取得と画像取得の関数を実行するとバグるので
                    //名前を取得できたことを確認してから画像を取得します。
                    FetchUserImage()
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    private func UpdateUsername(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(Realname).updateData([
            "Username": Username
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    //Tastes
    private func FetchUserTastes(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(Realname).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["Tastes"] as? [String] {
                    UserTastesList = fieldValue
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    private func UpdateUserTastes(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(Realname).updateData([
            "EnrollmentCampus": AllCampus[CampusSelectionIndexValue]
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    //EnrollmentCampus
    private func FetchEnrollmentCampus(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(Realname).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.data()?["EnrollmentCampus"] as? String{
                    for i in 0..<AllCampus.count{
                        if fieldValue == AllCampus[i]{
                            CampusSelectionIndexValue = i
                            break
                        }
                    }
                } else {
                    print("Field not found or cannot be converted to String.")
                }
            } else {
                print("Document does not exits.")
            }
        }
    }
}
