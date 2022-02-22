//
//  BottomSheet.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/4.
//

import SwiftUI

struct BottomSheet<V: View>: ViewModifier {
    @Binding var isPresented: Bool
    let block: () -> V
    let dismiss: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented {
                    ZStack(alignment: .topTrailing) {
                        block()
                        
                        Button {
                            withAnimation {
                                isPresented = false
                            }
                            
                            if let dismiss = dismiss {
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.secondary)
                                .font(.title)
                                .padding()
                        }
                    }
                    .transition(.move(edge: .bottom).animation(.spring()))
                }
            }
    }
}
