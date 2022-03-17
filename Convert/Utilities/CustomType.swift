//
//  CustomType.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-13.
//

import Foundation

struct UnitInfo: Hashable, Codable {
    var cName: String
    var eName: String?
    var abbr: String?
    var symbol: String?
    var image: String?
    
    init(cName: String, eName: String? = nil, abbr: String? = nil, symbol: String? = nil, image: String? = nil) {
        self.cName = cName
        self.eName = eName
        self.abbr = abbr
        self.symbol = symbol
        self.image = image
    }
}

enum ConversionType: String, CaseIterable {
    case currency = "货币"
    case length = "长度"
    case area = "面积"
    case volume = "容积"
    case mass = "重量"
    case speed = "速度"
    case temperature = "温度"
    case time = "时间"
    case energy = "能量"
}

enum ServiceError: Error, Hashable {
    case fetchingFailure
    case conversionFailure
    
    var localizedDescription: String {
        switch self {
        case .fetchingFailure:
            return "无法使用该转换功能"
        case .conversionFailure:
            return "无法转换"
        }
    }
}

struct ConversionResult: Equatable {
    var type: ConversionType
    var fromValue: String
    var fromUnit: UnitInfo
    var toValue: Double
    var toUnit: UnitInfo
}

enum ColorScheme: Int {
    case unspecified
    case light
    case dark
}

enum ScientificNotationMode: Int {
    case partiallyEnabled
    case enabled
    case disabled
}

enum CurrencyCopyFormat: Int {
    case complete
    case withCurrencyCodeOrName
    case withCurrencySymbol
}

enum DocType: String, CaseIterable {
    case reminder = "使用说明"
    case cheatsheet = "单位列表"
}

enum ButtonType: Hashable {
    case numeric(String)
    case functional(String)
    case operant(String)
    
    var label: String {
        switch self {
        case .numeric(let str), .functional(let str), .operant(let str):
            return str
        }
    }
}
