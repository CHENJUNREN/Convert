//
//  Input.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

struct InputBox: View {
    
    @AppStorage(wrappedValue: 2, "preferredResultAccuracy") var resultAccuracy
    
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
                .frame(width: geo.size.width, height: viewModel.conversionResult == nil ? geo.size.height : (geo.size.height - 10) / 8)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(30)
                .padding(.bottom, viewModel.conversionResult == nil ? 0 : 10)
                .animation(.easeInOut, value: viewModel.conversionResult)
                .onSubmit {
                    if !text.isEmpty {
                        Task {
                            await viewModel.fetchConversionResult(for: text)
                            text = ""
                        }
                    }
                }
            
            if let result = viewModel.conversionResult {
                VStack(alignment: .center, spacing: 5) {
                    
                    if result.type == .currency {
                        CurrencyConversionResultPresentation(
                            value: result.fromValue,
                            code: result.fromUnit.abbr!,
                            symbol: result.fromUnit.symbol,
                            flag: result.fromUnit.image,
                            name: result.fromUnit.cName)
                    } else {
                        NormalConversionResultPresentation(
                            value: result.fromValue,
                            symbol: result.fromUnit.symbol!,
                            name: result.fromUnit.cName)
                    }
                    
                    Image(systemName: "arrow.down.circle")
                        .gradientForeground()
                        .font(.largeTitle)
                    
                    Group {
                        if result.type == .currency {
                            CurrencyConversionResultPresentation(
                                value: formattedResult(for: result.toValue, with: resultAccuracy, using: .decimal),
                                code: result.toUnit.abbr!,
                                symbol: result.toUnit.symbol,
                                flag: result.toUnit.image,
                                name: result.toUnit.cName)
                        } else {
                            NormalConversionResultPresentation(
                                value: formattedResult(for: result.toValue, with: resultAccuracy, using: .decimal),
                                symbol: result.toUnit.symbol!,
                                name: result.toUnit.cName)
                        }
                    }
                    .contextMenu {
                        Button {
                            UIPasteboard.general.string = "\(result.toValue)"
                        } label: {
                            Label("拷贝数值", systemImage: "arrow.right.doc.on.clipboard")
                        }
                    }
                }
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
    
    func formattedResult(for result: Double, with accuracy: Int, using numberStyle: NumberFormatter.Style) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = accuracy
        formatter.exponentSymbol = "×10^"
        
        if (abs(result).isLess(than: pow(10, -Double(accuracy))) || !abs(result).isLessThanOrEqualTo(pow(10, 8))) {
            formatter.numberStyle = .scientific
        } else {
            formatter.numberStyle = numberStyle
        }
        
        return formatter.string(from: .init(value: result))!
    }
}

struct NormalConversionResultPresentation: View {
    
    let value: String
    let symbol: String
    let name: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack(alignment: .center, spacing: 5) {
                Text(value)
                    .font(.largeTitle)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Text(symbol)
            }
            .font(.title)
            
            Text(name)
                .font(.title2)
        }
        .foregroundColor(.secondary)
        .padding(10)
    }
}

struct CurrencyConversionResultPresentation: View {
    
    let value: String
    let code: String
    let symbol: String?
    let flag: String?
    let name: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack(alignment: .center, spacing: 5) {
                if let symbol = symbol {
                    Text(symbol)
                        .font(.title)
                }
                
                Text(value)
                    .font(.largeTitle)
                    .lineLimit(1)
                    .foregroundColor(.primary)
            }
            
            HStack {
                Text(code)
                
                if let flag = flag {
                    Text(flag)
                }
                
                Text(name)
            }
            .font(.title2)
        }
        .foregroundColor(.secondary)
        .padding(10)
    }
}
