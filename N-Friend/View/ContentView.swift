//
//  ContentView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct ContentView: View {
    var UserUID: String
    
    var body: some View {
        TabView {
            CardSwipeView(UserUID: UserUID)
                .tabItem {
                    Image(systemName: "magazine.fill")
                }
            LikedMatchedView(UserUID: UserUID)
                .tabItem {
                    Image(systemName: "heart.fill")
                }
            ProfileView(UserUID: UserUID)
                .tabItem {
                    Image(systemName: "person")
                }
        }.accentColor(.mint).navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView(UserUID: "")
}
