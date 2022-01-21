//
//  NoticeBox.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-09.
//

import SwiftUI

struct NoticeBox: View {
    @Binding var showNotice: Bool
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("备注", systemImage: "list.bullet.rectangle.portrait")
                        .gradientForeground()
                        .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            showNotice.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.right.circle")
                            .rotationEffect(showNotice ? .degrees(90) : .degrees(0))
                    }
                }
                
                if showNotice {
                    VStack(alignment: .leading, spacing: 5) {
                        Label("查阅下表或搜索已支持的转换类型及单位", systemImage: "1.circle")
                        Label("可长按条目拷贝单位", systemImage: "2.circle")
                        Label("转换**货币**时, 请使用货币代码", systemImage: "3.circle")
                        Label("转换其他单位时, 可使用中文或英文缩写", systemImage: "4.circle")
                    }
                    .foregroundColor(.secondary)
                    .font(.footnote)
                }
            }
        }
        .padding(.horizontal)
    }
}
