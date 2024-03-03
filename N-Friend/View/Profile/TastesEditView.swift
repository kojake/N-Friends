//
//  TastesEditView.swift
//  N-Friend
//
//  Created by kaito on 2024/03/02.
//

import SwiftUI
import FirebaseFirestore

struct TastesEditView: View {
    var Realname: String
    
    @State var TastesList: [[String]] = [
        ["読書", "映画鑑賞", "英会話"],
        ["カメラ","ジョキング","ネットサーフィン"],
        ["音楽","ペット","散歩"],
        ["瞑想","ヨガ","貯金"],
        ["スポーツ観戦","ゲーム","料理"],
        ["DIY","ゴルフ","テニス"],
        ["温泉巡り","ホームパーティー","食べ歩き"],
        ["ボルダリング","釣り","ダーツ"],
        ["プラモデル","アニメ・漫画","観葉植物"],
        ["トランプ","裁縫・手芸","アクセサリー"],
        ["キャンプ","筋トレ","旅行"],
        ["ツーリング","乗馬","コスプレ"],
        ["折り紙","切り絵","占い"],
        ["古本屋巡り","ブログ","アフェリエイト"],
        ["ネットオークション","イラスト・デザイン", "プログラミング"],
    ]
    @Binding var UserTastesList: [String]
    
    var body: some View {
        VStack{
            HStack{
                Text("趣味").font(.largeTitle).fontWeight(.semibold).padding()
                Spacer()
            }
            Spacer()
            ScrollView{
                VStack{
                    ForEach(0..<TastesList.count, id: \.self) { y in
                        HStack{
                            ForEach(0..<TastesList[y].count, id: \.self) { x in
                                Button(action: {
                                    var is_match = false
                                    for i in 0..<UserTastesList.count{
                                        if TastesList[y][x] == UserTastesList[i]{
                                            UserTastesList.remove(at: i)
                                            is_match = true
                                            break
                                        }
                                    }
                                    if !is_match{
                                        UserTastesList.append(TastesList[y][x])
                                    }
                                }){
                                    Text(TastesList[y][x]).fontWeight(.semibold).frame(width: 110, height: 50).background(MatchingTaste(index: TastesList[y][x]) ? Color.gray : Color.blue).foregroundColor(Color.white).cornerRadius(10)
                                }
                            }
                        }
                    }
                }
            }
        }.onDisappear{
            UpdateUserTastes()
        }
    }
    private func MatchingTaste(index: String) -> Bool {
        for i in 0..<UserTastesList.count {
            if index == UserTastesList[i]{
                return true
            }
        }
        return false
    }
    private func UpdateUserTastes(){
        let db = Firestore.firestore()
        
        db.collection("UserList").document(Realname).updateData([
            "Tastes": UserTastesList
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
