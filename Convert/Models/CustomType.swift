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

// TODO: 改的合理点
enum ServiceError: Error, Hashable {
    case systemFailure
    case fetchingFailure
    case conversionFailure
    
    var localizedDescription: String {
        switch self {
        case .systemFailure:
            return "系统异常, 请检查相关设置, 例如网络连接"
        case .fetchingFailure:
            return "暂时无法使用该(转换)服务"
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
