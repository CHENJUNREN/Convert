//
//  VolumeConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-19.
//

import Foundation

class VolumeConversionService: ConversionService, LinearConversion {
    
    static let shared = VolumeConversionService()
    
    private init() {}
    
    let type: ConversionType = .volume
    
    lazy var units: [(UnitVolume, UnitInfo)] =
    [
        (.liters, UnitInfo(cName: "升", eName: "Liter", abbr: "l")),
        (.milliliters, UnitInfo(cName: "毫升", eName: "Milliliter", abbr: "ml")),
        (.cubicKilometers, UnitInfo(cName: "立方千米", eName: "Cubic Kilometer", abbr: "km3")),
        (.cubicKilometers, UnitInfo(cName: "立方公里", eName: "Cubic Kilometer", abbr: "km3")),
        (.cubicMeters, UnitInfo(cName: "立方米", eName: "Cubic Meter", abbr: "m3")),
        (.cubicMeters, UnitInfo(cName: "立方公尺", eName: "Cubic Meter", abbr: "m3")),
        (.cubicDecimeters, UnitInfo(cName: "立方分米", eName: "Cubic Decimeter", abbr: "dm3")),
        (.cubicCentimeters, UnitInfo(cName: "立方厘米", eName: "Cubic Centimeter", abbr: "cm3")),
        (.cubicMillimeters, UnitInfo(cName: "立方毫米", eName: "Cubic Millimeter", abbr: "mm3")),
        (.cubicInches, UnitInfo(cName: "立方英寸", eName: "Cubic Inch", abbr: "in3")),
        (.cubicFeet, UnitInfo(cName: "立方英尺", eName: "Cubic Foot", abbr: "ft3")),
        (.cubicYards, UnitInfo(cName: "立方码", eName: "Cubic Yard", abbr: "yd3")),
        (.cubicMiles, UnitInfo(cName: "立方英里", eName: "Cubic Mile", abbr: "mi3")),
        (.acreFeet, UnitInfo(cName: "英亩英尺", eName: "Acre Foot", abbr: "af")),
//        (.bushels, UnitInfo(cName: "蒲式耳", eName: "Bushel", abbr: "bsh")),
        (.fluidOunces, UnitInfo(cName: "液量盎司", eName: "Fluid Ounce", abbr: "floz")),
        (.imperialFluidOunces, UnitInfo(cName: "英液量盎司", eName: "Imperial Fluid Ounce", abbr: "ifloz")),
        (.pints, UnitInfo(cName: "品脱", eName: "Pint", abbr: "pt")),
        (.imperialPints, UnitInfo(cName: "英品脱", eName: "Imperial Pint", abbr: "ipt")),
        (.quarts, UnitInfo(cName: "夸脱", eName: "Quart", abbr: "qt")),
        (.imperialQuarts, UnitInfo(cName: "英夸脱", eName: "Imperial Quart", abbr: "iqt")),
        (.gallons, UnitInfo(cName: "加仑", eName: "Gallon", abbr: "gal")),
        (.imperialGallons, UnitInfo(cName: "英加仑", eName: "Imperial Gallon", abbr: "igal")),
    ]
}

extension UnitVolume {
    static let cubicCentimeters = UnitVolume(symbol: "cm³", converter: UnitConverterLinear(coefficient: 0.001))
}
