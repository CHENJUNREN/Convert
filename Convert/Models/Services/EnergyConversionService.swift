//
//  EnergyConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-19.
//

import Foundation

class EnergyConversionService: ConversionService, LinearConversion {
    
    static let shared = EnergyConversionService()
    
    private init() {}
    
    let type: ConversionType = .energy
    
    lazy var units: [(UnitEnergy, UnitInfo)] =
    [
        (.kilojoules, UnitInfo(cName: "千焦", eName: "Kilojoule", abbr: "kj")),
        (.joules, UnitInfo(cName: "焦", eName: "Joule", abbr: "j")),
        (.kilocalories, UnitInfo(cName: "千卡", eName: "Kilocalorie", abbr: "kcal")),
        (.calories, UnitInfo(cName: "卡", eName: "Calorie", abbr: "cal")),
    ]
}
