//
//  AreaConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-18.
//

import Foundation

class AreaConversionService: ConversionService, LinearConversion {
    
    static let shared = AreaConversionService()
    
    private init() {}
    
    let type: ConversionType = .area
    
    lazy var units: [(UnitArea, UnitInfo)] =
    [
        (.squareKilometers, UnitInfo(cName: "平方千米", eName: "Square Kilometer", abbr: "sqkm")),
        (.squareKilometers, UnitInfo(cName: "平方公里", eName: "Square Kilometer", abbr: "sqkm")),
        (.squareMeters, UnitInfo(cName: "平方米", eName: "Square Meter", abbr: "sqm")),
        (.squareMeters, UnitInfo(cName: "平方公尺", eName: "Square Meter", abbr: "sqm")),
        (.squareCentimeters, UnitInfo(cName: "平方厘米", eName: "Square Centimeter", abbr: "sqcm")),
        (.squareMillimeters, UnitInfo(cName: "平方毫米", eName: "Square Millimeter", abbr: "sqmm")),
        (.squareMicrometers, UnitInfo(cName: "平方微米", eName: "Square Micrometer", abbr: "squm")),
        (.squareNanometers, UnitInfo(cName: "平方纳米", eName: "Square Nanometer", abbr: "sqnm")),
        (.squareInches, UnitInfo(cName: "平方英寸", eName: "Square Inch", abbr: "sqin")),
        (.squareFeet, UnitInfo(cName: "平方英尺", eName: "Square Foot", abbr: "sqft")),
        (.squareYards, UnitInfo(cName: "平方码", eName: "Square Yard", abbr: "sqyd")),
        (.squareMiles, UnitInfo(cName: "平方英里", eName: "Square Mile", abbr: "sqmi")),
        (.acres, UnitInfo(cName: "英亩", eName: "Acre", abbr: "ac")),
        (.ares, UnitInfo(cName: "公亩", eName: "Are", abbr: "a")),
        (.hectares, UnitInfo(cName: "公顷", eName: "Hectare", abbr: "ha")),
        (.mus, UnitInfo(cName: "亩")),
        (.qings, UnitInfo(cName: "顷")),
    ]
    
}

extension UnitArea {
    
    static let qings = UnitArea(symbol: "顷", converter: UnitConverterLinear(coefficient: 10000*100/15))
    
    static let mus = UnitArea(symbol: "亩", converter: UnitConverterLinear(coefficient: 10000/15))
}
