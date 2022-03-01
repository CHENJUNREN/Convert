//
//  CalculatorViewModel.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/26.
//

import Foundation
import MathExpression

class CalculatorViewModel: ObservableObject {
    
    @Published var invalidAttempts = 0
    @Published var expression = ""
    
    let calculatorButtons: [[ButtonType]] = [
        [.functional("AC"), .operant("("), .operant(")"), .functional("←")],
        [.numeric("7"), .numeric("8"), .numeric("9"), .operant("×")],
        [.numeric("4"), .numeric("5"), .numeric("6"), .operant("-")],
        [.numeric("1"), .numeric("2"), .numeric("3"), .operant("+")],
        [.numeric("0"), .operant("."), .operant("÷"), .functional("=")],
    ]
    
    func action(for button: ButtonType) {
        switch button {
        case .numeric(let str), .operant(let str):
            if expression.isEmpty {
                expression = str
            } else {
                expression += str
            }
        case .functional(let str):
            if str == "AC" {
                expression = ""
            } else if str == "←" {
                if !expression.isEmpty {
                    expression.removeLast()
                }
            } else {
                if !expression.isEmpty {
                    expression = evaluateExpression()
                }
            }
        }
    }
    
    func evaluateExpression() -> String {
        let ex = expression
                    .replacingOccurrences(of: "×", with: "*")
                    .replacingOccurrences(of: "÷", with: "/")
        do {
            let mathExpression = try MathExpression(ex, transformation: nil)
            return mathExpression.evaluate().formattedForCalculation()
        } catch {
            print("❗️❗️❗️ Calculation error: \(error.localizedDescription)")
            invalidAttempts += 1
            return expression
        }
    }
    
    func isExpressionAValue() -> Bool {
        return Double(expression) != nil
    }
}

enum ButtonType: Hashable {
    case numeric(String)
    case functional(String)
    case operant(String)
    
    var label: String {
        switch self {
        case .numeric(let str), .functional(let str), .operant(let str):
            return str
        }
    }
}
