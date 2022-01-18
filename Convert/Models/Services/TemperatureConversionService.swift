//
//  TemperatureConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-02.
//

import Foundation

class TemperatureConversionService: ConversionService, LinearConversion {
    
    static let shared = TemperatureConversionService()
    
    private init() {}

    let type: ConversionType = .temperature
    
    lazy var units: [(UnitTemperature, UnitInfo)] =
    [
        (.celsius, UnitInfo(cName: "摄氏度", eName: "Celsius", abbr: "c")),
        (.kelvin, UnitInfo(cName: "开尔文", eName: "Kelvin", abbr: "k")),
        (.fahrenheit, UnitInfo(cName: "华氏度", eName: "Fahrenheit", abbr: "f")),
    ]
}
