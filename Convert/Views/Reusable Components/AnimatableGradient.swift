//
//  AnimatableGradient.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/25.
//

import SwiftUI

struct AnimatableGradient: Animatable, ViewModifier {
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

extension View {
    func animatableGradientForeground(fromGradient: Gradient, toGradient: Gradient, percentage: CGFloat) -> some View {
        modifier(AnimatableGradient(percentage: percentage, fromGradient: fromGradient, toGradient: toGradient))
    }
}
