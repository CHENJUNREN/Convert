//
//  DismissButton.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/13.
//

import SwiftUI

struct DismissButton: View {
    let action: DismissAction
    
    init(action: DismissAction) {
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.secondary)
        }
    }
}
