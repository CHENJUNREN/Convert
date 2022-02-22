//
//  Double+extensions.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/1/28.
//

import Foundation

extension Double {
    static let sharedFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.exponentSymbol = "×10^"
        return formatter
    }()
    
    func formatted(with accuracy: Int, usingScientificNotation: Int, usingGroupingSeparator: Bool) -> String {
        let formatter = Self.sharedFormatter
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
        
        return Utils.superscriptize(str: formatter.string(from: .init(value: self))!)
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
