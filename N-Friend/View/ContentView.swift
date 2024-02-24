//
//  ContentView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("")
                .tabItem {
                    Image(systemName: "menucard.fill")
                }
            Text("")
                .tabItem {
                    Image(systemName: "tray.fill")
                }
            Text("")
                .tabItem {
                    Image(systemName: "heart")
                }
            Text("")
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
