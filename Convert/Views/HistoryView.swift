//
//  HistoryView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/13.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.managedObjectContext) var moc
    
    @AppStorage("resultAccuracy") var resultAccuracy = 2
    @AppStorage("usesGroupingSeparator") var usesGroupingSeparator = true
    @AppStorage("scientificNotationMode") var scientificNotationMode = ScientificNotationMode.partiallyEnabled
    @AppStorage("showUnitInChinese") var showUnitInChinese = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.updatedAt, ascending: false)],
        predicate: nil,
        animation: .default
    ) var records: FetchedResults<Record>
    
    @StateObject private var viewModel = HistoryViewModel()
    @State var showWarning = false
    
    var body: some View {
        mainScreen
            .navigationTitle("转换记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
                        .disabled(records.isEmpty)
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
            }
    }
    
    var mainScreen: some View {
        ZStack {
            if !records.isEmpty {
                historyList
            } else {
                Text("无历史数据😅")
                    .foregroundColor(.secondary)
                    .font(.title2.weight(.light))
            }
        }
        .transition(.opacity.animation(.default))
    }
    
    var historyList: some View {
        List {
            ForEach(records, id: \.conversionType) { record in
                Section {
                    ForEach(record.unwrappedConversions, id: \.id) { conversion in
                        let toValue = conversion.toValue
                            .formatted(
                                with: resultAccuracy,
                                scientificNotationMode: scientificNotationMode,
                                usesGroupingSeparator: usesGroupingSeparator
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
                                .tint(.accentColor)
                                
                                Button(role: .destructive) {
                                    viewModel.delete(conversion)
                                } label: {
                                    Image(systemName: "trash.fill")
                                }
                            }
                    }
                } header: {
                    Text(record.conversionType ?? "")
                }
            }
        }
    }
}

struct EntryCell: View {
    let fromValue: String
    let fromUnit: String
    let toValue: String
    let toUnit: String
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Text(fromValue)
                    .fontWeight(.bold)
        
                Spacer()
        
                Text(fromUnit)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
            }
            .minimumScaleFactor(0.2)
            .lineLimit(1)
        
            Image(systemName: "arrow.right.circle.fill")
                .symbolRenderingMode(.multicolor)
                .foregroundColor(.accentColor)
                .padding(.horizontal)
        
            HStack {
                Text(toValue)
                    .fontWeight(.bold)
        
                Spacer()
        
                Text(toUnit)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
            }
            .minimumScaleFactor(0.2)
            .lineLimit(1)
        }
    }
}

//HStack(spacing: 0) {
//    VStack(alignment: .leading, spacing: 2.5) {
//        Text(fromValue)
//            .fontWeight(.bold)
//
//        Text(fromUnit)
//            .fontWeight(.light)
//            .foregroundColor(.secondary)
//    }
//    .minimumScaleFactor(0.2)
//    .lineLimit(1)
//    .frame(maxWidth: .infinity, alignment: .leading)
//
//    Image(systemName: "arrow.right.circle.fill")
//        .symbolRenderingMode(.multicolor)
//        .foregroundColor(.accentColor)
//        .padding(.horizontal)
//
//    VStack(alignment: .trailing, spacing: 2.5) {
//        Text(toValue)
//            .fontWeight(.bold)
//
//        Text(toUnit)
//            .fontWeight(.light)
//            .foregroundColor(.secondary)
//    }
//    .minimumScaleFactor(0.2)
//    .lineLimit(1)
//    .frame(maxWidth: .infinity, alignment: .trailing)
//}
