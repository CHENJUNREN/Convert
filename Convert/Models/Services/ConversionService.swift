//
//  ConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-29.
//

import Foundation

protocol ConversionService {
    
    var type: ConversionType { get }
    
    func supportedUnits() async -> Result<[UnitInfo], ServiceError>
    
    func convert(_ value: Double, from unit1: String, to unit2: String) -> Result<ConversionResult, ServiceError>
}


protocol LinearConversion {
    
    associatedtype UnitType: Dimension
    
    var units: [(UnitType, UnitInfo)] { get }
}


extension ConversionService where Self: LinearConversion {

    func supportedUnits() async -> Result<[UnitInfo], ServiceError> {
        .success(units.map { entry in entry.1 })
    }
    
    func convert(_ value: Double, from unit1: String, to unit2: String) -> Result<ConversionResult, ServiceError> {

        guard var fromUnit = (units.first { $0.1.cName == unit1 || $0.1.abbr == unit1.lowercased() }) else { return .failure(.conversionFailure) }
        
        guard var toUnit = (units.first { $0.1.cName == unit2 || $0.1.abbr == unit2.lowercased() }) else { return .failure(.conversionFailure) }
        
        let measurement = Measurement(value: value, unit: fromUnit.0).converted(to: toUnit.0)
        
        fromUnit.1.symbol = fromUnit.0.symbol
        toUnit.1.symbol = toUnit.0.symbol
        
        return .success(ConversionResult(type: self.type, fromValue: value.description, fromUnit: fromUnit.1, toValue: measurement.value, toUnit: toUnit.1))
    }
}
