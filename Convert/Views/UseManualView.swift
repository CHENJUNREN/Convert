//
//  UseManualView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/3/4.
//

import SwiftUI

struct UseManualView: View {
    @Binding var selectedDoc: DocType
    @Binding var selectedConversionType: ConversionType
    
    var body: some View {
        mainScreen
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("选择查看的文档", selection: $selectedDoc) {
                        ForEach(DocType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .fixedSize()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var mainScreen: some View {
        switch selectedDoc {
        case .reminder:
            NoteView()
        case .cheatsheet:
            CheatSheetView(selectedConversionType: $selectedConversionType)
        }
    }
}

enum DocType: String, CaseIterable {
    case reminder = "使用说明"
    case cheatsheet = "单位列表"
}
