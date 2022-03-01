//
//  BottomSheet.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/4.
//

import SwiftUI

struct BottomSheet<V: View>: ViewModifier {
    @Binding var isPresented: Bool
    let showDismissButton: Bool
    let block: () -> V
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented {
                    VStack(spacing: 0) {
                        if showDismissButton {
                            HStack {
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        isPresented = false
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundColor(.secondary)
                                        .font(.title)
                                }
                            }
                            .padding()
                        }
                        
                        block()
                    }
                    .transition(.move(edge: .bottom).animation(.spring()))
                    .background(.thinMaterial)
                }
            }
    }
}

extension View {
    func bottomSheet<V: View>(isPresented: Binding<Bool>, showDismissButton: Bool = true, content: @escaping () -> V) -> some View {
        modifier(BottomSheet(isPresented: isPresented, showDismissButton: showDismissButton, block: content))
    }
}
