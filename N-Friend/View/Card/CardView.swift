//
//  CardView.swift
//  N-Friend
//
//  Created by kaito on 2024/02/24.
//

import SwiftUI

struct CardView: View {
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var dragState: DragState = .none

    enum DragState {
        case none
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .none: return .zero
            case .dragging(let translation): return translation
            }
        }
        
        var isDragging: Bool {
            if case .dragging = self {
                return true
            }
            return false
        }
    }
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in
                self.dragState = .dragging(translation: value.translation)
                self.offset = value.translation
                self.rotation = Double(self.offset.width / 20)
            }
            .onEnded { value in
                self.dragState = .none
                self.offset = .zero
                self.rotation = 0
            }
        
        return ZStack{
            Image("Person1").resizable()
            VStack{
                Spacer()
                HStack{
                    VStack(alignment: .leading){
                        Text("Username").font(.title2).fontWeight(.black)
                        Text("興味/趣味")
                        Spacer()
                        HStack{
                            Text("")
                        }
                        Spacer()
                    }.padding()
                    Spacer()
                }.frame(width: 300, height: 120).background(Color.blue.opacity(0.5))
            }
        }.frame(width: 300, height: 450).background(Color.gray).cornerRadius(20).shadow(radius: 10)
            .offset(self.dragState.translation)
            .rotationEffect(Angle(degrees: self.rotation))
            .gesture(dragGesture)
            .animation(.spring())
            .opacity(self.offset.width == 0 ? 1 : 0.5)
            .rotationEffect(Angle(degrees: self.offset.width == 0 ? 0 : (self.offset.width > 0 ? 10 : -10)))
            .animation(.easeInOut)
            .onTapGesture {
                withAnimation {
                    self.offset = .zero
                    self.rotation = 0
                }
            }
    }
}

#Preview {
    CardView()
}
