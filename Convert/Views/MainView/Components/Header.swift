//
//  Header.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-21.
//

import SwiftUI

struct Header: View {
    @State var gradientValue = 0.0
    
    var body: some View {
        HStack {
//            Text("Convert.")
//                .font(.custom("Menlo", size: 48, relativeTo: .largeTitle))
//                .fontWeight(.ultraLight)
            Text("就是转换。")
                .font(.largeTitle.bold())
                .animatableGradientForeground(fromGradient: Gradient(colors: [.pink, .accentColor]),
                                              toGradient: Gradient(colors: [.red, .indigo]),
                                              percentage: gradientValue)
                .animation(.linear(duration: 5.0).delay(5.0).repeatForever(autoreverses: true), value: gradientValue)
            
            Spacer()
            
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
            }
        }
        .padding(.bottom)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            gradientValue = 1.0
        }
    }
}
