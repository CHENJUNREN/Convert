//
//  ResultPresentation.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-21.
//

import SwiftUI

struct ResultPresentation: View {
    @EnvironmentObject var globalState: GlobalState
    @EnvironmentObject var viewModel: HomeViewModel
    
    @AppStorage("resultAccuracy") var resultAccuracy = 2
    @AppStorage("usesGroupingSeparator") var usesGroupingSeparator = true
    @AppStorage("scientificNotationMode") var scientificNotationMode = ScientificNotationMode.partiallyEnabled
    
    let result: ConversionResult
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            fromValueView
            
            Image(systemName: "arrow.down.circle")
                .symbolRenderingMode(.hierarchical)
                .gradientForeground()
                .font(.largeTitle)
            
            toValueView
        }
    }
    
    @ViewBuilder
    var fromValueView: some View {
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
    }
    
    @ViewBuilder
    var toValueView: some View {
        let formattedToValue = result.toValue.formatted(
            with: resultAccuracy,
            scientificNotationMode: scientificNotationMode,
            usesGroupingSeparator: usesGroupingSeparator
        )
        
        Group {
            if result.type == .currency {
                CurrencyResultPresentation(
                    value: formattedToValue,
                    code: result.toUnit.abbr!,
                    symbol: result.toUnit.symbol,
                    flag: result.toUnit.image,
                    name: result.toUnit.cName)
            } else {
                NormalResultPresentation(
                    value: formattedToValue,
                    symbol: result.toUnit.symbol!,
                    name: result.toUnit.cName)
            }
        }
        .onLongPressGesture {
            UIPasteboard.general.string = viewModel.generateCopyString(value: formattedToValue, type: result.type, unit: result.toUnit)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            withAnimation {
                globalState.showCopySuccess = true
            }
        }
    }
}

struct NormalResultPresentation: View {
    let value: String
    let symbol: String
    let name: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Text(value)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
                
                Text(symbol)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.2)
            
            Text(name)
                .font(.title2.weight(.light))
                .lineLimit(1)
                .minimumScaleFactor(0.2)
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
            HStack {
                if let symbol = symbol, symbol != code {
                    Text(symbol)
                }
                
                Text(value)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
                
                Text(code)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.2)
            
            HStack {
                Text(name)
                    .font(.title2.weight(.light))
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
