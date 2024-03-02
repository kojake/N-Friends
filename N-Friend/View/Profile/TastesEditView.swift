//
//  TastesEditView.swift
//  N-Friend
//
//  Created by kaito on 2024/03/02.
//

import SwiftUI

struct TastesEditView: View {
    @State var SelectionTastesList: [[String]] = [
        ["読書", "映画鑑賞", "英会話"],
        ["カメラ","ジョキング","ネットサーフィン"],
        ["音楽","ペット","散歩"],
        ["瞑想","ヨガ","貯金"],
        ["スポーツ観戦","ゲーム","料理"],
    ]
    @State var TastesList: [String] = ["読書","カメラ","スポーツ観戦"]
    
    var body: some View {
        VStack{
            HStack{
                Text("趣味").font(.largeTitle).fontWeight(.semibold).padding()
                Spacer()
            }
            Spacer()
            ScrollView{
                VStack{
                    ForEach(0..<5) { y in
                        HStack{
                            ForEach(0..<3) { x in
                                Button(action: {
                                    var match = false
                                    for i in 0..<TastesList.count{
                                        if SelectionTastesList[y][x] == TastesList[i]{
                                            TastesList.remove(at: i)
                                            match = true
                                            break
                                        }
                                    }
                                    if !match{
                                        TastesList.append(SelectionTastesList[y][x])
                                    }
                                }){
                                    Text(SelectionTastesList[y][x]).fontWeight(.semibold).frame(width: 110, height: 50).background(matchingTaste(index: SelectionTastesList[y][x]) ? Color.gray : Color.blue).foregroundColor(Color.white).cornerRadius(10)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func matchingTaste(index: String) -> Bool {
        for i in 0..<TastesList.count {
            if index == TastesList[i]{
                return true
            }
        }
        return false
    }
}

#Preview {
    TastesEditView()
}
