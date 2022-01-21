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
    
    var body: some View {
        List {
            Section {
                Stepper("精度: 小数点后 \(resultAccuracy) 位", value: $resultAccuracy, in: 0...5, step: 1) { bool in
                    
                }
            }
            
            Section {
                Picker(selection: $selectedAppearance, label: Text("外观")) {
                    Text("系统").tag(0)
                    Text("亮色").tag(1)
                    Text("暗色").tag(2)
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
