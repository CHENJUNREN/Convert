//
//  AcknowledgmentView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/8.
//

import SwiftUI

struct AcknowledgmentView: View {
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                first
                    .padding(.bottom)
                second
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("致谢")
    }
    
    var first: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("第三方 SDK & API", systemImage: "gear.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.headline)
                Spacer()
            }
            
            Text("Special thanks to the software developers, **Fawaz Ahmed** and **Pere Daniel Prieto**.🤝")
                .font(.subheadline)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("currency-api")
                    
                    Button {
                        openURL(URL(string: "https://github.com/fawazahmed0/currency-api")!)
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .opacity(0.5)
                    }
                }
                
                HStack {
                    Text("MathExpression")
                    
                    Button {
                        openURL(URL(string: "https://github.com/peredaniel/MathExpression")!)
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .opacity(0.5)
                    }
                }
            }
            .font(.subheadline.bold().monospaced())
            .padding(.leading, 5)
        }
        .clippedToRoundedRectangle(background: .linearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundColor(.white)
    }
    
    var second: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "heart.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.headline)
                
                Spacer()
            }
            
            Text("反正写在最后应该没有人会看吧, 特别感谢 **朱彬旖** 这些年来的陪伴和帮助, 虽然最近发生了很多不愉快的事情, 但还是非常感谢.🙏")
        }
        .font(.subheadline)
        .foregroundColor(.white)
        .clippedToRoundedRectangle(background: .linearGradient(colors: [.orange, .red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct AcknowledgmentView_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgmentView()
    }
}
