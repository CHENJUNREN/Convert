//
//  SheetView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/16.
//

import SwiftUI

struct SheetView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    let content: () -> Content
    
    init(content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        NavigationView {
            content()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        DismissButton(action: dismiss)
                    }
                }
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView {
            Text("Hello, World!")
        }
    }
}
