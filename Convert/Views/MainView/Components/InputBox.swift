//
//  Input.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

struct InputBox: View {
    
    @EnvironmentObject var viewModel: MasterViewModel
    
    @State var text: String = ""
    @FocusState.Binding var focusTextField: Bool
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack(spacing: 0) {
            TextField(textFieldPrompt(error: viewModel.conversionError, result: viewModel.conversionResult), text: $text)
                .font(viewModel.conversionResult == nil ? .largeTitle : .title2)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .submitLabel(.search)
                .focused($focusTextField)
                .onSubmit {
                    if !text.isEmpty {
                        Task {
                            await viewModel.fetchConversionResult(for: text)
                            text = ""
                        }
                    }
                }
                .frame(width: geo.size.width, height: viewModel.conversionResult == nil ? geo.size.height : (geo.size.height - 10) / 8)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(30)
                .padding(.bottom, viewModel.conversionResult == nil ? 0 : 10)
                .animation(.easeInOut, value: viewModel.conversionResult)
            
            if let result = viewModel.conversionResult {
                ResultPresentation(result: result)
                    .frame(width: geo.size.width, height: (geo.size.height - 10) / 8 * 7)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(30)
                    .transition(.opacity.combined(with: .scale).animation(.easeInOut))
                    .animation(.easeInOut, value: viewModel.conversionResult)
            }
        }
        .frame(width: geo.size.width, height: geo.size.height)
    }
    
    func textFieldPrompt(error: ServiceError?, result: ConversionResult?) -> String {
        if error == nil && result == nil {
            return "点击输入查询"
        } else if error == nil {
            return "长按结果可以拷贝哦"
        } else {
            return error!.localizedDescription
        }
    }
}
