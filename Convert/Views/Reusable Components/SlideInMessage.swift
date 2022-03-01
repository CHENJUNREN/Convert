//
//  SlideInMessage.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/18.
//

import SwiftUI

struct SlideInMessage<V: View>: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let autoDismiss: Bool
    let icon: () -> V
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isPresented {
                    Label {
                        Text(message)
                            .foregroundColor(.secondary)
                    } icon: {
                        icon()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(.regularMaterial)
                    .clipShape(Capsule())
                    .padding(.top, 5)
                    .transition(.move(edge: .top).combined(with: .opacity).animation(.default))
                    .onAppear {
                        if autoDismiss {
                            Task {
                                try? await Task.sleep(nanoseconds: 2_000_000_000)
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }
                    }
                }
            }
    }
}

extension View {
    func slideInMessage<V: View>(isPresented: Binding<Bool>, message: String, autoDismiss: Bool = true, icon: @escaping () -> V) -> some View {
        modifier(SlideInMessage(isPresented: isPresented, message: message, autoDismiss: autoDismiss, icon: icon))
    }
}
