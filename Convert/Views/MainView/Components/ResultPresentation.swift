//
//  ResultPresentation.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-21.
//

import SwiftUI

struct ResultPresentation: View {
    
    @AppStorage(wrappedValue: 2, "preferredResultAccuracy") var resultAccuracy
    
    let result: ConversionResult
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
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
                        value: result.toValue.formatted(with: resultAccuracy, using: .decimal),
                        code: result.toUnit.abbr!,
                        symbol: result.toUnit.symbol,
                        flag: result.toUnit.image,
                        name: result.toUnit.cName)
                } else {
                    NormalResultPresentation(
                        value: result.toValue.formatted(with: resultAccuracy, using: .decimal),
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
    }
}

struct NormalResultPresentation: View {
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

struct CurrencyResultPresentation: View {
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

extension Double {
    func formatted(with accuracy: Int, using numberStyle: NumberFormatter.Style) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = accuracy
        formatter.exponentSymbol = "×10^"
        
        if (abs(self).isLess(than: pow(10, -Double(accuracy))) || !abs(self).isLessThanOrEqualTo(pow(10, 8))) {
            formatter.numberStyle = .scientific
        } else {
            formatter.numberStyle = numberStyle
        }
        
        return formatter.string(from: .init(value: self))!
    }
}
