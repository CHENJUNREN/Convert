//
//  ResultPresentation.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-21.
//

import SwiftUI

struct ResultPresentation: View {
    
    @AppStorage(wrappedValue: 2, "preferredResultAccuracy") var resultAccuracy
    @AppStorage(wrappedValue: false, "usingScientificNotation") var usingScientificNotation
    
    @State var showCopyMessage = false
    
    let result: ConversionResult
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if result.type == .currency {
                CurrencyResultPresentation(
                    value: result.fromValue,
                    code: result.fromUnit.abbr!,
                    symbol: result.fromUnit.symbol,
                    flag: result.fromUnit.image,
                    name: result.fromUnit.cName)
            } else {
                NormalResultPresentation(
                    value: result.fromValue,
                    symbol: result.fromUnit.symbol!,
                    name: result.fromUnit.cName)
            }
            
            Image(systemName: "arrow.down.circle")
                .gradientForeground()
                .font(.largeTitle)
            
            Group {
                if result.type == .currency {
                    CurrencyResultPresentation(
                        value: result.toValue.formatted(with: resultAccuracy,
                                                        usingScientificNotation: usingScientificNotation),
                        code: result.toUnit.abbr!,
                        symbol: result.toUnit.symbol,
                        flag: result.toUnit.image,
                        name: result.toUnit.cName)
                } else {
                    NormalResultPresentation(
                        value: result.toValue.formatted(with: resultAccuracy,
                                                        usingScientificNotation: usingScientificNotation),
                        symbol: result.toUnit.symbol!,
                        name: result.toUnit.cName)
                }
            }
            .onLongPressGesture {
                UIPasteboard.general.string = result.toValue.formatted(with: resultAccuracy,
                                                                       usingScientificNotation: usingScientificNotation)
                showCopyMessage = true
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
        }
        .showMessagePopUp(imageName: "checkmark.circle.fill", message: "拷贝成功", isShowing: $showCopyMessage)
    }
}

struct NormalResultPresentation: View {
    let value: String
    let symbol: String
    let name: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                Text(value)
                    .font(.largeTitle.weight(.semibold))
                    .lineLimit(1)
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.2)
                
                Text(symbol)
                    .padding(.leading, 7.5)
            }
            
            Text(name)
        }
        .font(.title.weight(.light))
        .foregroundColor(.secondary)
        .padding()
    }
}

struct CurrencyResultPresentation: View {
    let value: String
    let code: String
    let symbol: String?
    let flag: String?
    let name: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                if let symbol = symbol {
                    Text(symbol)
                        .padding(.trailing, 2)
                }
                
                Text(value)
                    .font(.largeTitle.weight(.semibold))
                    .lineLimit(1)
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.2)
                
                Text(code)
                    .padding(.leading, 7.5)
            }
            
            HStack {
                Text(name)
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
                
                if let flag = flag {
                    Text(flag)
                }
            }
        }
        .font(.title.weight(.light))
        .foregroundColor(.secondary)
        .padding()
    }
}
