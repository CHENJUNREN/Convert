//
//  NoteView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-09.
//

import SwiftUI

struct NoteView: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Note(title: "列表使用", icon: "list.bullet.rectangle.portrait", messages: [
                    "浏览或搜索**单位列表**, 看是否已支持您想要转换的类型及单位",
                    "长按单个条目可以拷贝其单位",
                    "转换**货币**单位时, 请使用货币代码(英文缩写)",
                    "转换其他类型时, 可以使用中文名称或英文缩写",
                ])
                    .padding(.bottom)
                
                Note(title: "拷贝结果", icon: "arrow.right.doc.on.clipboard", messages: [
                    "完成转换后, 长按下方结果可以进行拷贝",
                    "在**转换记录**页面中, 左滑条目也可以进行拷贝"
                ])
                    .padding(.bottom)
                
                Note(title: "手势操作", icon: "hand.draw", messages: [
                    "仅适用于主页面",
                    "上滑 —— 打开**转换记录**页面",
                    "下滑或点击空白处 —— 收起键盘",
                    "左滑 —— 进入**设置**页面"
                ])
                    .padding(.bottom)
                
                Note(title: "其他说明", icon: "ellipsis.bubble", messages: [
                    "软件默认会保存所有的转换结果, 可以在**转换记录**页面中左滑不需要的条目进行删除, 仅保留常用的",
                ])
            }
            .padding()
        }
    }
}

struct Note: View {
    let title: String
    let icon: String
    let messages: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label {
                    Text(title)
                } icon: {
                    Image(systemName: icon)
                }
                .font(.headline)
                .gradientForeground()
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 7.5) {
                ForEach(messages.indices, id: \.self) { index in
                    Label {
                        Text(try! AttributedString(markdown: messages[index]))
                    } icon: {
                        Image(systemName: "\(index + 1).circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .foregroundColor(.secondary)
                    .font(.footnote)
                }
            }
        }
        .clippedToRoundedRectangle(background: Color(uiColor: .secondarySystemBackground))
    }
}
