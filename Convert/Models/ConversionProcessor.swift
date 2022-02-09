//
//  ConversionProcessor.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-27.
//

import Foundation

class ConversionProcessor {
    
    static let shared: ConversionProcessor = ConversionProcessor()
    
    private init() {}
    
    private let conversionServices: [ConversionService] = [
        CurrencyConversionService.shared,
        LengthConversionService.shared,
        TemperatureConversionService.shared,
        MassConversionService.shared,
        TimeConversionService.shared,
        AreaConversionService.shared,
        SpeedConversionService.shared,
        EnergyConversionService.shared,
        VolumeConversionService.shared,
    ]
    
    func supportedConversionAndUnits() async -> [ConversionType:Result<[UnitInfo], ServiceError>] {
        
        let taskGroupResult = await withTaskGroup(of: (ConversionType, Result<[UnitInfo], ServiceError>).self) {
            group -> [ConversionType:Result<[UnitInfo], ServiceError>] in
            
            for service in conversionServices {
                group.addTask {
                    return await (service.type, service.supportedUnits())
                }
            }
            
            var result: [ConversionType:Result<[UnitInfo], ServiceError>] = [:]
            for await value in group {
                result[value.0] = value.1
            }
            return result
        }
        
        return taskGroupResult
    }
    
    func conversionResult(for query: String) async -> Result<ConversionResult, ServiceError> {
        
        // parsing query
        let splitted = query.split(separator: " ").map { String($0) }
        guard splitted.count == 3 else { return .failure(.conversionFailure) }
        guard let value = Double(splitted[0]) else { return .failure(.conversionFailure) }
        
        let taskGroupResult = await withTaskGroup(of: Result<ConversionResult, ServiceError>.self) { (group) -> Result<ConversionResult, ServiceError> in
            for service in conversionServices {
                group.addTask {
                    return service.convert(value, from: splitted[1], to: splitted[2])
                }
            }

            for await result in group {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(var conversionResult):
                    conversionResult.fromValue = splitted[0]
                    return .success(conversionResult)
                }
            }
            
            return .failure(.conversionFailure)
        }
        
        return taskGroupResult
    }
}
