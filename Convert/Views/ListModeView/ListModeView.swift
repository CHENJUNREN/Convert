//
//  ListModeView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/1.
//

import SwiftUI

struct ListModeView: View {
    @State var selectedConversionType = ConversionType.currency
    @State var valueToConvert: Double = 1.0
    @State var selectedUnit = "m"
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("选择一个转换类型", selection: $selectedConversionType) {
                ForEach(ConversionType.allCases, id: \.self) { type in
                    Text("\(type.rawValue)")
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding(.vertical)
            
            HStack {
                TextField("输入转换数值", value: $valueToConvert, format: .number, prompt: Text("输入转换数值"))
                    .textFieldStyle(.plain)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(.regularMaterial)
                    .cornerRadius(15)
                
                Picker("选择一个单位", selection: $selectedUnit) {
                    Text("m")
                        .tag("m")
                    
                    Text("cm")
                        .tag("cm")
                }
                .pickerStyle(.menu)
                .foregroundColor(.primary)
                .padding(.vertical, 6)
                .padding(.horizontal, 15)
                .background(.regularMaterial)
                .cornerRadius(15)
            }
            
            Spacer()
        }
    }
}

struct ListModeView_Previews: PreviewProvider {
    static var previews: some View {
        ListModeView()
    }
}
