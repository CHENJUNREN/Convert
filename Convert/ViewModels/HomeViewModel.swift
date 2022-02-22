//
//  HomeViewModel.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-27.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    let conversionProcessor: ConversionProcessor = .shared
    let persistenceController = PersistenceController.shared
    
    @Published var conversionResult: ConversionResult?
    @Published var conversionError: ServiceError?
    
    func fetchConversionResult(for query: String) async {
        conversionError = nil
        switch await conversionProcessor.conversionResult(for: query) {
        case .failure(let error):
            conversionError = error
        case .success(let result):
            conversionResult = result
            persist(result)
        }
    }
    
    func generateCopyString(value: String, type: ConversionType, unit: UnitInfo) -> String {
        let copyAlongWithUnit = UserDefaults.standard.bool(forKey: "copyAlongWithUnit")
        let copyUnitInChinese = UserDefaults.standard.bool(forKey: "copyUnitInChinese")
        let currencyCopyFormat = UserDefaults.standard.integer(forKey: "currencyCopyFormat")
        
        if copyAlongWithUnit {
            if type == .currency {
                if currencyCopyFormat == 0 || currencyCopyFormat == 2 {
                    let symbol = unit.symbol == nil ? "" : "\(unit.symbol!) "
                    let code = " " + (copyUnitInChinese ? unit.cName : unit.abbr!)
                    return symbol + value + (currencyCopyFormat == 0 ? code : "")
                } else {
                    return value + " \(copyUnitInChinese ? unit.cName : unit.abbr!)"
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
                symbol: result.type == .currency ? result.fromUnit.abbr! : result.fromUnit.symbol!
            )
            
            let toUnit = Unit(
                context: context,
                name: result.toUnit.cName,
                symbol: result.type == .currency ? result.toUnit.abbr! : result.toUnit.symbol!
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
