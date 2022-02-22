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
    
    func slideInMessage<V: View>(isPresented: Binding<Bool>, message: String, autoDismiss: Bool = true, icon: @escaping () -> V) -> some View {
        modifier(SlideInMessage(isPresented: isPresented, message: message, autoDismiss: autoDismiss, icon: icon))
    }
    
    func bottomSheet<V: View>(isPresented: Binding<Bool>, content: @escaping () -> V, onDimiss: (() -> Void)? = nil) -> some View {
        modifier(BottomSheet(isPresented: isPresented, block: content, dismiss: onDimiss))
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
