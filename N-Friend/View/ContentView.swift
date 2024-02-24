//
//  ContentView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
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
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
