//
//  AcknowledgmentView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/8.
//

import SwiftUI

struct AcknowledgmentView: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                iconCreator
                    .padding(.bottom)
                
                thirdParties
                    .padding(.bottom)
                
                special
            }
            .padding()
            .foregroundColor(.white)
            .font(.subheadline)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("致谢")
    }
    
    var thirdParties: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("第三方 SDK & API", systemImage: "gear.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.headline)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2.5) {
                HStack {
                    Text("currency-api")
                    
                    Link(destination: URL(string: "https://github.com/fawazahmed0/currency-api")!) {
                        Image(systemName: "arrow.right.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                
                HStack {
                    Text("MathExpression")
                    
                    Link(destination: URL(string: "https://github.com/peredaniel/MathExpression")!) {
                        Image(systemName: "arrow.right.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .font(.subheadline.bold().monospaced())
            .opacity(0.8)
            .padding(.leading, 15)
            
            Text("Special thanks to the software developers, **Fawaz Ahmed** and **Pere Daniel Prieto**")
        }
        .clippedToRoundedRectangle(background: .linearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    var iconCreator: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("应用图标", systemImage: "star.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.headline)
                Spacer()
            }

            Text("本应用图标中部分图标由 **Royyan Wijaya** 创作, 有需要可以前往他的主页寻找心仪的图标")
            
            Link(destination: URL(string: "https://www.flaticon.com/authors/royyan-wijaya")!) {
                Image(systemName: "arrow.right.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            .font(.subheadline.bold())
            .opacity(0.8)
        }
        .clippedToRoundedRectangle(background: .linearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    var special: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "heart.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.headline)
                Spacer()
            }
            
            Text("特别感谢 Lucia 这些年来的陪伴和帮助, 感谢她能一直包容我的任性和不成熟, 感谢她给我带来了一段特别美好的回忆")
                .fontWeight(.bold)
        }
        .clippedToRoundedRectangle(background: .linearGradient(colors: [.orange, .red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct AcknowledgmentView_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgmentView()
    }
}
