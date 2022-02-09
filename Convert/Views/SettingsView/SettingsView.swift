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
    @AppStorage(wrappedValue: false, "usingScientificNotation") var usingScientificNotation
    @AppStorage(wrappedValue: 0, "preferredMode") var selectedMode
    
    @FocusState<Bool> var focusNumPad
    
    var body: some View {
        List {
            Section {
                HStack(alignment: .center) {
                    Label {
                        Text("小数点后")
                    } icon: {
                        Image(systemName: "ruler")
                            .foregroundColor(.primary)
                    }
                    
                    TextField("结果最大精度", value: $resultAccuracy, format: .number, prompt: Text(""))
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
                Text("转换结果最大精度")
            }
            
            Section {
                Toggle(isOn: $usingScientificNotation) {
                    Label {
                        Text("使用科学计数法")
                    } icon: {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            .foregroundColor(.primary)
                    }
                }
            } header: {
                Text("转换结果显示")
            } footer: {
                Text("仅针对特别大或者特别小的数值，例如小于 10^-8，大于 10^8 或者小于最大精度的数值")
            }
            
            Section {
                VStack(alignment: .leading) {
                    Label {
                        Text("转换模式")
                    } icon: {
                        Image(systemName: "filemenu.and.selection")
                            .foregroundColor(.primary)
                    }
                    
                    Picker(selection: $selectedMode, label: Text("转换模式")) {
                        Text("输入查询").tag(0)
                        Text("1 转多").tag(1)
                        Text("1 转 1").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 10)
            }
            
            Section {
                VStack(alignment: .leading) {
                    Label {
                        Text("外观")
                    } icon: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.primary)
                    }
                    
                    Picker(selection: $selectedAppearance, label: Text("外观")) {
                        Text("系统").tag(0)
                        Text("亮色").tag(1)
                        Text("暗色").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 10)
            }
            
            Section {
                Button {
                    Task {
                        await globalState.initServices()
                    }
                    dismiss()
                } label: {
                    Label("重新加载功能", systemImage: "arrow.clockwise")
                        .foregroundColor(.primary)
                }
            }
            
            Section {
                NavigationLink {
                    More()
                } label: {
                    Label {
                        Text("更多")
                    } icon: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
