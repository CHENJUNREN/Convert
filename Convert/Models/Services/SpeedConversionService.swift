//
//  SpeedConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-18.
//

import Foundation

class SpeedConversionService: ConversionService, LinearConversion {
    
    static let shared = SpeedConversionService()
    
    private init() {}
    
    let type: ConversionType = .speed
    
    lazy var units: [(UnitSpeed, UnitInfo)] =
    [
        (.metersPerSecond, UnitInfo(cName: "米/秒", eName: "Meter Per Second", abbr: "m/s")),
        (.kilometersPerHour, UnitInfo(cName: "千米/小时", eName: "Kilometer Per Hour", abbr: "km/h")),
        (.milesPerHour, UnitInfo(cName: "英里/小时", eName: "Mile Per Hour", abbr: "mph")),
        (.knots, UnitInfo(cName: "节", eName: "Knot", abbr: "kn")),
    ]
}
