//
//  ContentView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct ContentView: View {
    var UserUID: String
    @State var SelectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $SelectedTab) {
                CardSwipeView(UserUID: UserUID)
                    .tag(0)

                LikedMatchedView(UserUID: UserUID)
                    .tag(1)

                ProfileView(UserUID: UserUID)
                    .tag(2)
            }

            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            SelectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (SelectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 60)
            .background(.mint.opacity(0.4))
            .cornerRadius(10)
            .padding(.horizontal, 26)
        }
    }
}

enum TabbedItems: Int, CaseIterable{
    case Card = 0
    case Like
    case Profile
    
    var title: String{
        switch self {
        case .Card:
            return "CardSwipe"
        case .Like:
            return "LikeMatch"
        case .Profile:
            return "Profile"
        }
    }
    
    var iconName: String{
        switch self {
        case .Card:
            return "magazine.fill"
        case .Like:
            return "heart.fill"
        case .Profile:
            return "person.fill"
        }
    }
}

extension ContentView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .white : .gray)
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .white : .gray)
            }
            Spacer()
        }
        .frame(width: isActive ? .infinity : 60, height: 50)
        .background(isActive ? .black.opacity(0.4) : .clear)
        .cornerRadius(10)
    }
}

#Preview {
    ContentView(UserUID: "")
}
