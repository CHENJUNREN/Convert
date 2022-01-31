//
//  Double+extensions.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/1/28.
//

import Foundation

extension Double {
    func formatted(with accuracy: Int, usingScientificNotation: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.groupingSeparator = ","
        formatter.exponentSymbol = "×10^"
        formatter.maximumFractionDigits = accuracy
        
        if usingScientificNotation && shouldUseScientificNotation(requiredAccuracy: accuracy) {
            formatter.numberStyle = .scientific
        } else {
            formatter.numberStyle = .decimal
        }
        
        return formatter.string(from: .init(value: self))!
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
