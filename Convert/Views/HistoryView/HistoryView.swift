//
//  HistoryView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/13.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.managedObjectContext) var moc
    
    @AppStorage(wrappedValue: 2, "preferredResultAccuracy") var resultAccuracy
    @AppStorage(wrappedValue: 0, "usingScientificNotation") var usingScientificNotation
    @AppStorage(wrappedValue: true, "usingGroupingSeparator") var usingGroupingSeparator
    @AppStorage(wrappedValue: false, "copyAlongWithUnit") var copyAlongWithUnit
    @AppStorage(wrappedValue: false, "showUnitInChinese") var showUnitInChinese
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.updatedAt, ascending: false)],
        predicate: nil,
        animation: .default
    ) var records: FetchedResults<Record>
    
    @StateObject private var viewModel = HistoryViewModel()
    @State var showWarning = false
    
    var body: some View {
        historyList
            .navigationTitle("转换记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Menu {
                        Button(role: .destructive) {
                            showWarning = true
                        } label: {
                            Label("清空记录", systemImage: "trash.fill")
                        }
                        .disabled(records.isEmpty)
                        
                        Button {
                            showUnitInChinese.toggle()
                        } label: {
                            Label("切换单位样式", systemImage: "character.book.closed")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .alert("确认要清空所有转换记录?", isPresented: $showWarning) {
                Button("确认", role: .destructive) {
                    viewModel.deleteHistory()
                }
                Button("取消", role: .cancel) {
                }
            }
    }
    
    var historyList: some View {
        ZStack {
            if !records.isEmpty {
                List {
                    Text("左滑可以拷贝+删除当前条目🤭")
                    
                    ForEach(records, id: \.self) { record in
                        Section {
                            ForEach(record.unwrappedConversions, id: \.id) { conversion in
                                let toValue = conversion.toValue
                                    .formatted(
                                        with: resultAccuracy,
                                        usingScientificNotation: usingScientificNotation,
                                        usingGroupingSeparator: usingGroupingSeparator
                                    )
                                let fromValue = conversion.fromValue ?? ""
                                let fromUnit = showUnitInChinese ? conversion.from?.name ?? "" : conversion.from?.symbol ?? ""
                                let toUnit = showUnitInChinese ? conversion.to?.name ?? "" : conversion.to?.symbol ?? ""
                                
                                EntryCell(fromValue: fromValue, fromUnit: fromUnit, toValue: toValue, toUnit: toUnit)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button {
                                            let pastedString = viewModel.generateCopyString(value: toValue, unit: conversion.to!, type: ConversionType(rawValue: record.conversionType!)!)
                                            UIPasteboard.general.string = pastedString
                                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                                        } label: {
                                            Image(systemName: "arrow.right.doc.on.clipboard")
                                        }
                                        .tint(.blue)
                                        
                                        Button(role: ButtonRole.destructive) {
                                            viewModel.delete(conversion)
                                        } label: {
                                            Image(systemName: "trash.fill")
                                        }
                                    }
                            }
                        } header: {
                            Text(record.conversionType!)
                        }
                    }
                }
            } else {
                Text("无历史数据😅")
                    .foregroundColor(.secondary)
                    .font(.title2.weight(.thin))
            }
        }
        .transition(.opacity.animation(.default))
    }
}

struct EntryCell: View {
    let fromValue: String
    let fromUnit: String
    let toValue: String
    let toUnit: String
    
    var body: some View {
        HStack(spacing: 0) {
            GeometryReader { proxy in
                HStack {
                    Text(fromValue)
                        .fontWeight(.bold)
                    Text(fromUnit)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                }
                .minimumScaleFactor(0.2)
                .lineLimit(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            
            Image(systemName: "arrow.right.circle.fill")
                .symbolRenderingMode(.multicolor)
                .foregroundColor(.accentColor)
                .padding(.horizontal)
            
            GeometryReader { proxy in
                HStack {
                    Text(toValue)
                        .fontWeight(.bold)
                    Text(toUnit)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                }
                .minimumScaleFactor(0.2)
                .lineLimit(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            }
        }
    }
}
