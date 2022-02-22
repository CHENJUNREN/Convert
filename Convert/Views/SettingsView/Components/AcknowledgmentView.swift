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
            
            Text("货币转换数据由 **exchangerate.host** 提供")
            Text("Special thanks to **exchangerate.host** for providing currency conversion data")
                .foregroundColor(.secondary)
            Text("[https://exchangerate.host/](https://exchangerate.host/)")
        }
        .font(.footnote)
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
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
            
            Text("特别感谢 **朱彬旖** 这几年来对我的帮助，间接促使我完成了这一款对我来说真正意义上的独立开发软件，感谢🙏")
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

struct More_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgmentView()
    }
}
