//
//  SettingsView.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("colorScheme") var selectedColorScheme = ColorScheme.unspecified
    @AppStorage("resultAccuracy") var resultAccuracy = 2
    @AppStorage("usesGroupingSeparator") var usesGroupingSeparator = true
    @AppStorage("scientificNotationMode") var selectedScientificNotationMode = ScientificNotationMode.partiallyEnabled
    @AppStorage("copyAlongWithUnit") var copyAlongWithUnit = false
    @AppStorage("copyUnitInChinese") var copyUnitInChinese = false
    @AppStorage("currencyCopyFormat") var currencyCopyFormat = CurrencyCopyFormat.complete
    
    @FocusState<Bool> var focusNumPad
    @State var showMailView = false
    @State var showDocView = false
    @State var showHistoryView = false
    @State var showAckView = false
    
    var body: some View {
        List {
            resultAccuracyControl
            
            resultDisplayControl
            
            copyControl
            
            reloadServicesControl
            
            appAppearanceControl
            
            presentDocsControl
            
            otherControls
        }
        .navigationTitle("更多")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showMailView) {
            MailView(data: .init(subject: "App 使用反馈", recipient: "convertApp@outlook.com", message: ""))
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showDocView) {
            SheetView {
                DocView()
            }
        }
        .sheet(isPresented: $showHistoryView) {
            SheetView {
                HistoryView()
            }
        }
        .sheet(isPresented: $showAckView) {
            SheetView {
                AcknowledgmentView()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    focusNumPad = false
                } label: {
                    Label("完成", systemImage: "keyboard.chevron.compact.down")
                        .foregroundColor(.primary)
                        .labelStyle(.titleAndIcon)
                }
            }
        }
    }
    
    var resultAccuracyControl: some View {
        Section {
            HStack(alignment: .center) {
                Label {
                    Text("小数点后")
                } icon: {
                    Image(systemName: "ruler")
                        .foregroundColor(.primary)
                }
                
                TextField("输出最大精度", value: $resultAccuracy, format: .number, prompt: Text(""))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .focused($focusNumPad)
                    .frame(width: 40)
                
                Text("位")
            }
        } header: {
            Text("结果最大精度")
        }
    }
    
    var resultDisplayControl: some View {
        Section {
            Toggle(isOn: $usesGroupingSeparator) {
                Label("使用千位分隔符", systemImage: "figure.stand.line.dotted.figure.stand")
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading) {
                Label("科学计数法", systemImage: "rectangle.and.pencil.and.ellipsis")
                    .foregroundColor(.primary)
                
                Picker("科学计数法", selection: $selectedScientificNotationMode) {
                    Text("部分使用").tag(ScientificNotationMode.partiallyEnabled)
                    Text("使用").tag(ScientificNotationMode.enabled)
                    Text("不使用").tag(ScientificNotationMode.disabled)
                }
                .pickerStyle(.segmented)
            }
            .padding(.vertical, 10)
        } header: {
            Text("结果展示")
        } footer: {
            VStack(alignment: .leading, spacing: 5) {
                Label("在整数部分每隔 3 位插入分隔符(,)", systemImage: "1.circle.fill")
                Label("**部分使用**模式下，仅针对大于 \(Utils.superscriptize(str: "10^8"))，小于 \(Utils.superscriptize(str: "10^-8")) 或者小于最大精度的数值使用科学计数法显示", systemImage: "2.circle.fill")
            }
            .symbolRenderingMode(.hierarchical)
        }
    }
    
    var copyControl: some View {
        Section {
            Toggle(isOn: $copyAlongWithUnit) {
                Label("拷贝时带上单位", systemImage: "arrow.right.doc.on.clipboard")
                    .foregroundColor(.primary)
            }
            
            if copyAlongWithUnit {
                VStack(alignment: .leading) {
                    Label("单位样式", systemImage: "character.book.closed")
                        .foregroundColor(.primary)
                    
                    Picker("选择单位的样式", selection: $copyUnitInChinese) {
                        Text("100 m").tag(false)
                        Text("100 米").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Label("货币拷贝格式", systemImage: "yensign.circle")
                        .foregroundColor(.primary)
                    
                    Picker("选择货币拷贝格式", selection: $currencyCopyFormat) {
                        Text("¥ 100 \(copyUnitInChinese ? "人民币" : "CNY")")
                            .tag(CurrencyCopyFormat.complete)
                        Text("100 \(copyUnitInChinese ? "人民币" : "CNY")")
                            .tag(CurrencyCopyFormat.withCurrencyCodeOrName)
                        Text("¥ 100")
                            .tag(CurrencyCopyFormat.withCurrencySymbol)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 10)
            }
        } header: {
            Text("结果拷贝")
        } footer: {
            VStack(alignment: .leading, spacing: 5) {
                Label("长按首页转换结果可以拷贝", systemImage: "1.circle.fill")
                Label("在**转换记录**页面中，左滑条目也可以拷贝", systemImage: "2.circle.fill")
            }
            .symbolRenderingMode(.hierarchical)
        }
    }
    
    var reloadServicesControl: some View {
        Section {
            Button {
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    await globalState.initServices()
                }
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                dismiss()
            } label: {
                Label("重新加载功能", systemImage: "arrow.clockwise")
                    .foregroundColor(.primary)
            }
        } footer: {
            Text("重新加载需要联网使用的转换类型")
        }
    }
    
    var appAppearanceControl: some View {
        Section {
            VStack(alignment: .leading) {
                Label("外观", systemImage: "photo.on.rectangle.angled")
                    .foregroundColor(.primary)
                
                Picker("外观", selection: $selectedColorScheme) {
                    Text("系统").tag(ColorScheme.unspecified)
                    Text("亮色").tag(ColorScheme.light)
                    Text("暗色").tag(ColorScheme.dark)
                }
                .pickerStyle(.segmented)
            }
            .padding(.vertical, 10)
        }
    }
    
    var presentDocsControl: some View {
        Section {
            Button {
                showDocView = true
            } label: {
                Label("使用指南", systemImage: "doc.text.magnifyingglass")
                    .foregroundColor(.primary)
            }

            Button {
                showHistoryView = true
            } label: {
                Label("转换记录", systemImage: "clock")
                    .symbolRenderingMode(.multicolor)
                    .foregroundColor(.primary)
            }
        }
    }

    var otherControls: some View {
        Section {
            Button {
                showMailView = true
            } label: {
                Label("反馈意见", systemImage: "envelope")
                    .foregroundColor(MailView.canBePresented ? .primary : .secondary)
            }
            .disabled(!MailView.canBePresented)
            
//            Button {
//
//            } label: {
//                Label("支持一下", systemImage: "giftcard")
//                    .foregroundColor(.primary)
//            }
            
            Button {
                showAckView = true
            } label: {
                Label("致谢", systemImage: "heart.fill")
                    .symbolRenderingMode(.multicolor)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
