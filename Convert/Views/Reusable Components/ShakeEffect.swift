//
//  ShakeEffect.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/18.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var position: CGFloat
    
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -5 * sin(position * 2 * .pi), y: 0))
    }
}
