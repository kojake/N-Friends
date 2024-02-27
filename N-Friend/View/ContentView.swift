//
//  ContentView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct ContentView: View {
    var Realname: String
    
    var body: some View {
        TabView {
            CardSwipeView()
                .tabItem {
                    Image(systemName: "magazine.fill")
                }
            StarView()
                .tabItem {
                    Image(systemName: "star.fill")
                }
            ProfileView(Realname: Realname)
                .tabItem {
                    Image(systemName: "person")
                }
        }.navigationBarBackButtonHidden(true)
    }
}
