//
//  Double+extensions.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/1/28.
//

import Foundation

extension Double {
    static let conversionFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.exponentSymbol = "×10^"
        return formatter
    }()
    
    static let calculationFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.usesGroupingSeparator = false
        formatter.maximumFractionDigits = 20
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    func formattedForCalculation() -> String {
        return Self.calculationFormatter.string(from: NSNumber(value: self))!
    }
    
    func formatted(with accuracy: Int, usingScientificNotation: Int, usingGroupingSeparator: Bool) -> String {
        let formatter = Self.conversionFormatter
        formatter.groupingSeparator = usingGroupingSeparator ? "," : ""
        formatter.maximumFractionDigits = accuracy
        
        if usingScientificNotation == 0 {
            if shouldUseScientificNotation(requiredAccuracy: accuracy) {
                formatter.numberStyle = .scientific
            } else {
                formatter.numberStyle = .decimal
            }
        } else if usingScientificNotation == 1 {
            formatter.numberStyle = .scientific
        } else {
            formatter.numberStyle = .decimal
        }
        
        return Utils.superscriptize(str: formatter.string(from: NSNumber(value: self))!)
    }
    
    func shouldUseScientificNotation(requiredAccuracy: Int) -> Bool {
        let minThreshold = pow(10, -8.0)
        let maxThreshold = pow(10, 8.0)
        let accuracyThreshold = pow(10, -Double(requiredAccuracy))
        
        return (abs(self).isLess(than: accuracyThreshold) && abs(self).rounded(to: requiredAccuracy).isLess(than: accuracyThreshold))
        || abs(self).isLessThanOrEqualTo(minThreshold)
        || !abs(self).isLess(than: maxThreshold)
    }
    
    func rounded(to decimalPlace: Int) -> Double {
        (self * pow(10, Double(decimalPlace))).rounded() / pow(10, Double(decimalPlace))
    }
}
