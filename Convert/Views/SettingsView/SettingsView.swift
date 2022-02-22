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
    
    @AppStorage(wrappedValue: 2, "preferredResultAccuracy") var resultAccuracy
    @AppStorage(wrappedValue: 0, "preferredAppearance") var selectedAppearance
    @AppStorage(wrappedValue: 0, "usingScientificNotation") var usingScientificNotation
    @AppStorage(wrappedValue: true, "usingGroupingSeparator") var usingGroupingSeparator
    @AppStorage(wrappedValue: false, "copyAlongWithUnit") var copyAlongWithUnit
    @AppStorage(wrappedValue: false, "copyUnitInChinese") var copyUnitInChinese
    @AppStorage(wrappedValue: 0, "currencyCopyFormat") var currencyCopyFormat
    
    @FocusState<Bool> var focusNumPad
    @State var showMailView = false
    
    var body: some View {
        List {
            resultAccuracyControl
            
            resultDisplayControl
            
            copyControl
            
            reloadServicesControl
            
            appAppearanceControl
            
            conversionHistory
            
            otherControls
        }
        .navigationTitle("更多")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showMailView) {
            MailView(data: .init(subject: "App 使用反馈", recipient: "convertApp@outlook.com", message: ""))
                .ignoresSafeArea()
        }
    }
    
    var copyControl: some View {
        Section {
            Toggle(isOn: $copyAlongWithUnit) {
                Label("拷贝结果时带上单位", systemImage: "arrow.right.doc.on.clipboard")
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
                    
                    Picker("货币拷贝格式", selection: $currencyCopyFormat) {
                        Text("¥ 100 \(copyUnitInChinese ? "人民币" : "CNY")").tag(0)
                        Text("100 \(copyUnitInChinese ? "人民币" : "CNY")").tag(1)
                        Text("¥ 100").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 10)
            }
        } header: {
            Text("结果拷贝")
        }

    }
    
    var conversionHistory: some View {
        Section {
            // TODO: DOCVIEW here
            
            NavigationLink {
                HistoryView()
            } label: {
                Label("转换记录", systemImage: "clock")
                    .symbolRenderingMode(.multicolor)
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
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                focusNumPad = false
                            } label: {
                                Image(systemName: "keyboard.chevron.compact.down")
                            }
                        }
                    }
                
                Text("位")
            }
        } header: {
            Text("结果最大精度")
        }
    }
    
    var resultDisplayControl: some View {
        Section {
            Toggle(isOn: $usingGroupingSeparator) {
                Label {
                    Text("使用千位分隔符")
                } icon: {
                    Image(systemName: "figure.stand.line.dotted.figure.stand")
                        .foregroundColor(.primary)
                }
            }
            
            VStack(alignment: .leading) {
                Label {
                    Text("使用科学计数法")
                } icon: {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .foregroundColor(.primary)
                }
                
                Picker("使用科学计数法", selection: $usingScientificNotation) {
                    Text("部分使用").tag(0)
                    Text("使用").tag(1)
                    Text("不使用").tag(2)
                }
                .pickerStyle(.segmented)
            }
            .padding(.vertical, 10)
        } header: {
            Text("结果展示")
        } footer: {
            VStack(alignment: .leading, spacing: 5) {
                Label("在整数部分每隔 3 位插入分隔符", systemImage: "1.circle.fill")
                Label("**部分使用**模式下，仅针对大于 \(Utils.superscriptize(str: "10^8"))，小于 \(Utils.superscriptize(str: "10^-8")) 或者小于最大精度的数值使用科学计数法显示", systemImage: "2.circle.fill")
            }
            .foregroundColor(.secondary)
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
            Text("重新加载那些需要联网使用的转换类型")
        }
    }
    
    var appAppearanceControl: some View {
        Section {
            VStack(alignment: .leading) {
                Label {
                    Text("外观")
                } icon: {
                    Image(systemName: "photo.on.rectangle.angled")
                        .foregroundColor(.primary)
                }
                
                Picker("外观", selection: $selectedAppearance) {
                    Text("系统").tag(0)
                    Text("亮色").tag(1)
                    Text("暗色").tag(2)
                }
                .pickerStyle(.segmented)
            }
            .padding(.vertical, 10)
        }
    }
    
    var otherControls: some View {
        Section {
            Button {
                showMailView = true
            } label: {
                Label("反馈意见", systemImage: "envelope")
            }
            .disabled(!MailView.canBePresented)
            .foregroundColor(MailView.canBePresented ? .primary : .secondary)
            
//            Button {
//
//            } label: {
//                Label("支持一下", systemImage: "giftcard")
//                    .foregroundColor(.primary)
//            }
            
            NavigationLink {
                AcknowledgmentView()
            } label: {
                Label("致谢", systemImage: "heart.fill")
                    .symbolRenderingMode(.multicolor)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
