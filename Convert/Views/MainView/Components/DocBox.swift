//
//  Doc.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

struct DocBox: View {
    @Binding var presentDocView: Bool
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack(spacing: 20) {
            Label("使用指南", systemImage: "doc.plaintext")
                .font(.largeTitle)
                .gradientForeground()
            
            VStack(spacing: 5) {
                Text("查询格式:")
                    .font(.title3)
                Text("值 + 空格 + 单位 + 空格 + 转换单位")
                    .font(.headline)
                Text("例如, \"20 km cm\"")
                    .font(.callout)
            }
            .foregroundColor(.secondary)
            
            Button("查看更多") {
                presentDocView = true;
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .padding()
        .frame(width: geo.size.width, height: geo.size.height)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(30)
    }
}
