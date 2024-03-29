//
//  HomeViewModel.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-27.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    let conversionProcessor: ConversionProcessor = .shared
    let persistenceController = PersistenceController.shared
    
    @Published var conversionResult: ConversionResult?
    @Published var conversionError: ServiceError?
    @Published var textFieldInput = ""
    
    @MainActor
    func fetchConversionResult() async {
        conversionError = nil
        switch await conversionProcessor.conversionResult(for: textFieldInput) {
        case .failure(let error):
            conversionError = error
        case .success(let result):
            conversionResult = result
            persist(result)
            textFieldInput = ""
        }
    }
    
    func generateCopyString(value: String, type: ConversionType, unit: UnitInfo) -> String {
        let copyAlongWithUnit = UserDefaults.standard.bool(forKey: "copyAlongWithUnit")
        let copyUnitInChinese = UserDefaults.standard.bool(forKey: "copyUnitInChinese")
        let currencyCopyFormat = UserDefaults.standard.integer(forKey: "currencyCopyFormat")
        
        if copyAlongWithUnit {
            if type == .currency {
                let code = " " + (copyUnitInChinese ? unit.cName : unit.abbr!)
                if currencyCopyFormat == CurrencyCopyFormat.complete.rawValue
                    || currencyCopyFormat == CurrencyCopyFormat.withCurrencySymbol.rawValue
                {
                    let symbol = unit.symbol == nil ? "" : "\(unit.symbol!) "
                    return symbol + value + (currencyCopyFormat == CurrencyCopyFormat.complete.rawValue ? code : "")
                } else {
                    return value + code
                }
            } else {
                return value + " \(copyUnitInChinese ? unit.cName : unit.symbol!)"
            }
        } else {
            return value
        }
    }
    
    func persist(_ result: ConversionResult) {
        persistenceController.enqueue { context in
            let record = Record(context: context, type: result.type.rawValue)
            
            let fromUnit = Unit(
                context: context,
                name: result.fromUnit.cName,
                symbol: result.type == .currency ? result.fromUnit.abbr! : result.fromUnit.symbol!,
                prefixSymbol: result.type == .currency ? result.fromUnit.symbol : nil
            )
            
            let toUnit = Unit(
                context: context,
                name: result.toUnit.cName,
                symbol: result.type == .currency ? result.toUnit.abbr! : result.toUnit.symbol!,
                prefixSymbol: result.type == .currency ? result.toUnit.symbol : nil
            )
            
            let conversion = Conversion(
                context: context,
                fromValue: result.fromValue,
                toValue: result.toValue,
                from: fromUnit,
                to: toUnit
            )
            
            record.addToConversions(conversion)
        }
    }
}
