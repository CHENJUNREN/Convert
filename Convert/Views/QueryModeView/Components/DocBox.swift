//
//  Doc.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

struct DocBox: View {
    @Binding var presentDocView: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                Label("使用指南", systemImage: "doc.text.magnifyingglass")
                    .font(.title)
                .gradientForeground()
                
                VStack(spacing: 5) {
                    Text("查询格式:")
                        .font(.title3)
                    Text("值 + 空格 + 单位 + 空格 + 转换单位")
                        .font(.headline)
                    Text("例如, \"100 usd cny\"")
                        .font(.callout)
                }
                .foregroundColor(.secondary)
                
                Button("查看更多") {
                    presentDocView = true;
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(15)
        }
    }
}
