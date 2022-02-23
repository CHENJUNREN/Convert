//
//  Input.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

struct InputBox: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    @State var text: String = ""
    @FocusState.Binding var focusTextField: Bool
    @Binding var showHistoryView: Bool
    @State var showTips = false
    @State var invalidAttempts = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ZStack(alignment: .trailing) {
                    TextField(textFieldPrompt(), text: $text)
                        .multilineTextAlignment(.center)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.search)
                        .focused($focusTextField)
                        .padding(.horizontal)
                        .onSubmit {
                            if !text.isEmpty {
                                Task {
                                    await viewModel.fetchConversionResult(for: text)
                                    text = ""
                                    // generate error haptic feeback
                                    if viewModel.conversionError != nil {
                                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                                        invalidAttempts += 1
                                    }
                                    // show tips in textfield
                                    showTips = true
                                    try? await Task.sleep(nanoseconds: 10_000_000_000)
                                    showTips = false
                                }
                            }
                        }
                    
                    if viewModel.conversionResult != nil {
                        Button {
                            showHistoryView = true
                        } label: {
                            Image(systemName: "clock")
                                .symbolRenderingMode(.multicolor)
                                .padding(.horizontal, 10)
                        }
                        .transition(.scale.animation(.spring().delay(0.5)))
                    }
                }
                .font(viewModel.conversionResult == nil ? .largeTitle : .title3)
                .frame(width: geo.size.width, height: viewModel.conversionResult == nil ? geo.size.height : (geo.size.height - 10) / 8)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(15)
                .padding(.bottom, viewModel.conversionResult == nil ? 0 : 10)
                .animation(.spring(), value: viewModel.conversionResult)
                .modifier(ShakeEffect(shakes: invalidAttempts * 2))
                .animation(.default, value: invalidAttempts)
                
                if let result = viewModel.conversionResult {
                    ResultPresentation(result: result)
                        .frame(width: geo.size.width, height: (geo.size.height - 10) / 8 * 7)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(15)
                        .transition(.opacity.combined(with: .scale).animation(.spring()))
                        .animation(.default, value: viewModel.conversionResult)
                }
            }
        }
    }
    
    func textFieldPrompt() -> String {
        if !showTips {
            return "点击输入查询"
        } else {
            if viewModel.conversionError == nil {
                return "长按结果拷贝"
            } else {
                return viewModel.conversionError!.localizedDescription
            }
        }
    }
}
