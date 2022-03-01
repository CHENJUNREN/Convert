//
//  CalculatorView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/25.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject var viewModel = CalculatorViewModel()
    
    @Binding var textFieldInput: String
    @Binding var isPresented: Bool
    @FocusState.Binding var focusTextField: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(alignment: .lastTextBaseline) {
                Button {
                    withAnimation {
                        isPresented = false
                    }
                    textFieldInput = viewModel.expression + " "
                    focusTextField = true
                } label: {
                    Label("拷贝至输入框", systemImage: "arrow.up.doc.on.clipboard")
                        .foregroundColor(viewModel.isExpressionAValue() ? .primary : .secondary)
                        .font(.subheadline)
                }
                .disabled(!viewModel.isExpressionAValue())

                Spacer()
                
                Button {
                    withAnimation {
                        isPresented = false
                    }
                    focusTextField = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.secondary)
                        .font(.title)
                }
            }
            .padding()
            
            Text(viewModel.expression.isEmpty ? "输入完整计算公式" : viewModel.expression)
                .font(.title2.monospaced().bold())
                .foregroundColor(viewModel.expression.isEmpty ? .secondary : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(15)
                .padding(.horizontal, 15)
                .modifier(ShakeEffect(shakes: viewModel.invalidAttempts * 2))
                .animation(.default, value: viewModel.invalidAttempts)
            
            ButtonPad()
                .environmentObject(viewModel)
        }
    }
}

struct ButtonPad: View {
    @EnvironmentObject var viewModel: CalculatorViewModel
    
    let buttonWidth: CGFloat = (UIScreen.main.bounds.width - 2*15 - 3*10)/4
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.calculatorButtons, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { button in
                        Button {
                            viewModel.action(for: button)
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        } label: {
                            Text(button.label)
                                .font(font(for: button))
                                .frame(width: buttonWidth, alignment: .center)
                                .padding(.vertical, 10)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .foregroundColor(.primary)
                                .clipShape(Capsule())
                        }

                    }
                }
            }
        }
        .padding(15)
    }
    
    func font(for button: ButtonType) -> Font {
        switch button {
        case .numeric:
            return .title2.monospaced()
        case .functional:
            return .title2.monospaced().weight(.bold)
        case .operant:
            return .title2.monospaced().weight(.bold)
        }
    }
}
