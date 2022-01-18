//
//  DurationConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-17.
//

import Foundation

class TimeConversionService: ConversionService, LinearConversion {
    
    static let shared = TimeConversionService()
    
    private init() {}
    
    let type: ConversionType = .time
    
    lazy var units: [(UnitDuration, UnitInfo)] =
    [
        (.picoseconds, UnitInfo(cName: "皮秒", eName: "Picosecond", abbr: "ps")),
        (.nanoseconds, UnitInfo(cName: "纳秒", eName: "Nanosecond", abbr: "ns")),
        (.microseconds, UnitInfo(cName: "微秒", eName: "Microsecond", abbr: "us")),
        (.milliseconds, UnitInfo(cName: "毫秒", eName: "Millisecond", abbr: "ms")),
        (.seconds, UnitInfo(cName: "秒", eName: "Second", abbr: "s")),
        (.minutes, UnitInfo(cName: "分钟", eName: "Minute", abbr: "min")),
        (.hours, UnitInfo(cName: "小时", eName: "Hour", abbr: "hr")),
        (.days, UnitInfo(cName: "天", eName: "Day", abbr: "day")),
        (.weeks, UnitInfo(cName: "周", eName: "Week", abbr: "week")),
    ]
}

extension UnitDuration {
    
    static let days = UnitDuration(symbol: "day", converter: UnitConverterLinear(coefficient: 24 * 3600))
    
    static let weeks = UnitDuration(symbol: "week", converter: UnitConverterLinear(coefficient: 7 * 24 * 3600))
}
