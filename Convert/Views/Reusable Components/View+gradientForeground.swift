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
            LinearGradient(colors: [.pink, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .mask(self)
    }
}
