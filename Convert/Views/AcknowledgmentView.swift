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
            VStack(spacing: 25) {
                first
                
                second
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("致谢")
    }
    
    var first: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Label("技术支持", systemImage: "gear.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom, 5)
            
            Text("货币转换数据由 **Fawaz Ahmed** 提供")
            Text("Special thanks to **Fawaz Ahmed** for providing the currency conversion data")
                .foregroundColor(.secondary)
            Text("[fawazahmed0@GitHub](https://github.com/fawazahmed0/currency-api)")
        }
        .font(.footnote)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(15)
    }
    
    var second: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: "heart.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.headline)
                
                Spacer()
            }
            .padding(.bottom, 5)
            
            Text("反正写在最后应该没有人会看吧，特别感谢 **朱彬旖** 这些年来的陪伴和帮助，虽然最近发生了很多不愉快的事情，但还是非常感谢🙏")
        }
        .font(.subheadline)
        .padding()
        .foregroundColor(.white)
        .background {
            LinearGradient(colors: [.orange, .red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .cornerRadius(15)
    }
}

struct AcknowledgmentView_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgmentView()
    }
}
