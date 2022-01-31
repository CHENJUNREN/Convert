//
//  View+extensions.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-27.
//

import SwiftUI

extension View {
    func animatableGradientForeground(fromGradient: Gradient, toGradient: Gradient, percentage: CGFloat) -> some View {
        modifier(AnimatableGradientModifier(percentage: percentage, fromGradient: fromGradient, toGradient: toGradient))
    }
    
    func gradientForeground() -> some View {
        self.overlay {
            LinearGradient(colors: [.pink, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .mask(self)
    }
    
    func showMessagePopUp(imageName: String, message: String, isShowing: Binding<Bool>) -> some View {
        modifier(MessagePopUp(imageName: imageName, message: message, showMessagePopUp: isShowing))
    }
}

struct AnimatableGradientModifier: Animatable, ViewModifier {
    var percentage: CGFloat = 0.0
    let fromGradient: Gradient
    let toGradient: Gradient
    
    var animatableData: CGFloat {
        get { percentage }
        set { percentage = newValue }
    }
    
    func body(content: Content) -> some View {
        var colors = [Color]()
        
        for i in 0..<fromGradient.stops.count {
            let fromColor = UIColor(fromGradient.stops[i].color)
            let toColor = UIColor(toGradient.stops[i].color)
            colors.append(colorMixer(c1: fromColor, c2: toColor, percentage: percentage))
        }
        
        return content
            .overlay {
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            .mask(content)
    }
    
    func colorMixer(c1: UIColor, c2: UIColor, percentage: CGFloat) -> Color {
        guard let cc1 = c1.cgColor.components else { return Color(c1) }
        guard let cc2 = c2.cgColor.components else { return Color(c1) }
        
        let r = (cc1[0] + (cc2[0] - cc1[0]) * percentage)
        let g = (cc1[1] + (cc2[1] - cc1[1]) * percentage)
        let b = (cc1[2] + (cc2[2] - cc1[2]) * percentage)

        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }
}

struct MessagePopUp: ViewModifier {
    let imageName: String
    let message: String
    @Binding var showMessagePopUp: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .center) {
                if showMessagePopUp {
                    VStack(spacing: 10) {
                        Image(systemName: imageName)
                            .symbolRenderingMode(.multicolor)
                            .font(.largeTitle)
                        
                        Text(message)
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 110, height: 110)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .transition(.asymmetric(insertion: .opacity.combined(with: .scale).animation(.easeInOut(duration: 0.5)), removal: .opacity.animation(.easeInOut(duration: 1))))
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 1_500_000_000)
                            showMessagePopUp = false
                        }
                    }
                }
            }
    }
}
