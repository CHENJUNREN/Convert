//
//  SettingsView.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-26.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(wrappedValue: 2, "preferredResultAccuracy") var resultAccuracy
    @AppStorage(wrappedValue: 0, "preferredAppearance") var selectedAppearance
    @AppStorage(wrappedValue: false, "usingScientificNotation") var usingScientificNotation
    
    @FocusState<Bool> var focusNumPad
    
    var body: some View {
        List {
            Section {
                HStack(alignment: .center) {
                    Label {
                        Text("结果最大精度: 小数点后")
                    } icon: {
                        Image(systemName: "ruler")
                            .foregroundColor(.primary)
                    }
                    
                    TextField(value: $resultAccuracy, format: .number) {
                        Label {
                            Text("结果最大精度")
                        } icon: {
                            Image(systemName: "ruler")
                                .foregroundColor(.primary)
                        }
                    }
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .focused($focusNumPad)
                    .frame(width: 35)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("完成") {
                                focusNumPad = false
                            }
                        }
                    }
                    
                    Text("位")
                }
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
            } footer: {
                Text("仅针对特别大或者特别小的数值")
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
                VStack(alignment: .leading) {
                    HStack {
                        Label {
                            Text("感谢")
                        } icon: {
                            Image(systemName: "heart.fill")
                                .symbolRenderingMode(.multicolor)
                        }

                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("更多")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
