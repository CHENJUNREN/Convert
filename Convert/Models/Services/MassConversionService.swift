//
//  MassConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-06.
//

import Foundation

class MassConversionService: ConversionService, LinearConversion {
    
    static var shared = MassConversionService()
    
    private init() {}
    
    let type: ConversionType = .mass
    
    lazy var units: [(UnitMass, UnitInfo)] =
    [
        (.metricTons, UnitInfo(cName: "吨", eName: "Ton", abbr: "t")),
        (.kilograms, UnitInfo(cName: "千克", eName: "Kilogram", abbr: "kg")),
        (.kilograms, UnitInfo(cName: "公斤", eName: "Kilogram", abbr: "kg")),
        (.grams, UnitInfo(cName: "克", eName: "Gram", abbr: "g")),
        (.milligrams, UnitInfo(cName: "毫克", eName: "Milligram", abbr: "mg")),
        (.pounds, UnitInfo(cName: "磅", eName: "Pound", abbr: "lbs")),
        (.ounces, UnitInfo(cName: "盎司", eName: "Ounce", abbr: "oz")),
        (.stones, UnitInfo(cName: "英石", eName: "Stone", abbr: "st")),
        (.carats, UnitInfo(cName: "克拉", eName: "Carat", abbr: "ct")),
        (.ouncesTroy, UnitInfo(cName: "金衡制盎司", eName: "Ounce Troy", abbr: "ozt")),
        (.jins, UnitInfo(cName: "斤")),
        (.liangs, UnitInfo(cName: "两")),
    ]
}

extension UnitMass {
    
    static let jins = UnitMass(symbol: "斤", converter: UnitConverterLinear(coefficient: 1/2))
    
    static let liangs = UnitMass(symbol: "两", converter: UnitConverterLinear(coefficient: 1/20))
}

