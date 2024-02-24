//
//  InterestedSelectionView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct InterestedSelectionView: View {
    @State var InterestList: [String] = []
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text("興味/趣味").font(.largeTitle).fontWeight(.black)
                    Text("興味や趣味で自分に合った\n友達を見つけよう").fontWeight(.bold)
                }.padding()
                Spacer()
            }
            Spacer()
            ScrollView{
                
            }
            Spacer()
            Button(action: {
                
            }){
                Text("続ける").font(.title).fontWeight(.bold).frame(width: 200, height: 60).background(Color.blue.opacity(0.8)).foregroundColor(Color.white).cornerRadius(10)
            }.padding()
        }
    }
}

#Preview {
    InterestedSelectionView()
}
