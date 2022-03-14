//
//  View+gradientForeground.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-27.
//

import SwiftUI

extension View {
    func gradientForeground() -> some View {
        self.overlay {
            LinearGradient(colors: [.pink, .accentColor], startPoint: .bottomLeading, endPoint: .topTrailing)
        }
        .mask(self)
    }
    
    func clippedToRoundedRectangle<S: ShapeStyle>(background: S) -> some View {
        self
            .padding()
            .background(background)
            .cornerRadius(15)
    }
}
