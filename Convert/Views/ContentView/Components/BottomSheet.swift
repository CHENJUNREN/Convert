//
//  BottomSheet.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/4.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    var content: () -> Content
    var dismiss: () -> Void
    @State var offset: CGFloat = UIScreen.main.bounds.height
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>, content: @escaping () -> Content, dismiss: @escaping () -> Void) {
        self.content = content
        self.dismiss = dismiss
        _isPresented = isPresented
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
            
            ZStack(alignment: .topTrailing) {
                content()
                
                Button {
                    isPresented = false
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.secondary)
                        .font(.title)
                        .padding()
                }
            }
        }
        .offset(x: 0, y: offset)
        .animation(.spring(), value: offset)
        .onChange(of: isPresented) { newValue in
            offset = newValue ? 0 : UIScreen.main.bounds.height
        }
    }
}
