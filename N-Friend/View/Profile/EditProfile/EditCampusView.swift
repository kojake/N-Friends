//
//  EditCampusView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/27.
//

import SwiftUI

struct EditCampusView: View {
    @State var UserCurrentCampus: String = ""
    @State var CurrentCampusList: [String] = ["秋葉原","代々木","新宿"]
    
    var body: some View {
        VStack{
            List{
                ForEach(0..<CurrentCampusList.count, id: \.self) { campus in
                    HStack{
                        Text(CurrentCampusList[campus]).padding()
                    }
                }
            }.navigationTitle("Campus List")
        }
    }
}

#Preview {
    EditCampusView()
}
