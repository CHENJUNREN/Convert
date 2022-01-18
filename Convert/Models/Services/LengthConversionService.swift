//
//  LengthConversionService.swift.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-01.
//

import Foundation

class LengthConversionService: ConversionService, LinearConversion {
    
    static let shared = LengthConversionService()
    
    private init() {}
    
    let type: ConversionType = .length
    
    lazy var units: [(UnitLength, UnitInfo)] =
    [
        (.kilometers, UnitInfo(cName: "千米", eName: "Kilometer", abbr: "km")),
        (.kilometers, UnitInfo(cName: "公里", eName: "Kilometer", abbr: "km")),
        (.meters, UnitInfo(cName: "米", eName: "Meter", abbr: "m")),
        (.meters, UnitInfo(cName: "公尺", eName: "Meter", abbr: "m")),
        (.decimeters, UnitInfo(cName: "分米", eName: "Decimeter", abbr: "dm")),
        (.centimeters, UnitInfo(cName: "厘米", eName: "Centimeter", abbr: "cm")),
        (.millimeters, UnitInfo(cName: "毫米", eName: "Millimeter", abbr: "mm")),
        (.micrometers, UnitInfo(cName: "微米", eName: "Micrometer", abbr: "um")),
        (.nanometers, UnitInfo(cName: "纳米", eName: "Nanometer", abbr: "nm")),
        (.picometers, UnitInfo(cName: "皮米", eName: "Picometer", abbr: "pm")),
        (.miles, UnitInfo(cName: "英里", eName: "Mile", abbr: "mi")),
        (.yards, UnitInfo(cName: "码", eName: "Yard", abbr: "yd")),
        (.feet, UnitInfo(cName: "英尺", eName: "Foot", abbr: "ft")),
        (.inches, UnitInfo(cName: "英寸", eName: "Inch", abbr: "in")),
        (.lightyears, UnitInfo(cName: "光年", eName: "Light Year", abbr: "ly")),
        (.nauticalMiles, UnitInfo(cName: "海里", eName: "Nautical Mile", abbr: "nmi")),
        (.lis, UnitInfo(cName: "里")),
        (.zhangs, UnitInfo(cName: "丈")),
        (.chis, UnitInfo(cName: "尺")),
        (.cuns, UnitInfo(cName: "寸")),
    ]
}

extension UnitLength {
    
    static let lis = UnitLength(symbol: "里", converter: UnitConverterLinear(coefficient: 500))
    
    static let zhangs = UnitLength(symbol: "丈", converter: UnitConverterLinear(coefficient: 10/3))
    
    static let chis = UnitLength(symbol: "尺", converter: UnitConverterLinear(coefficient: 1/3))
    
    static let cuns = UnitLength(symbol: "寸", converter: UnitConverterLinear(coefficient: 1/30))
}
