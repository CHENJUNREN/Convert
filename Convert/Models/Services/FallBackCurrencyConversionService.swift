//
//  FallBackCurrencyConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/27.
//

import Foundation

// fall back implementation
//extension CurrencyConversionService {
//
//    private var conversionRateURL: URL {
//        URL(string: "https://api.exchangerate.host/latest?format=tsv&&base=\(baseCurrency)")!
//    }
//
//    private var supportedCurrenciesURL: URL {
//        URL(string: "https://api.exchangerate.host/symbols?format=csv")!
//    }
//
//    private func fetchSupportedCurrencies() async throws -> [UnitInfo] {
//
//        async let (data, response) = URLSession(configuration: .ephemeral).data(from: supportedCurrenciesURL)
//        async let nameMapping = String(contentsOf: currencyCodeToNameMappingFileURL)
//
//        guard let httpResponse = try await response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw ServiceError.fetchingFailure
//        }
//
//        guard let currencies = String(data: try await data, encoding: .utf8) else {
//            throw ServiceError.fetchingFailure
//        }
//
//        var nameMappingList = try await nameMapping.components(separatedBy: .newlines)
//        nameMappingList = nameMappingList.filter { !$0.isEmpty }
//        print("‼️‼️‼️ count of nameMappingList: \(nameMappingList.count)")
//
//        var currenciesList = currencies.components(separatedBy: .newlines)
//        currenciesList = currenciesList.filter { !$0.isEmpty }
//        // remove header of csv file
//        currenciesList.removeFirst()
//        print("‼️‼️‼️ count of currenciesList: \(currenciesList.count)")
//
//        var supportedCurrencies: [UnitInfo] = []
//        currenciesList.forEach { ele in
//            // remove quotation mark in csv file
//            let element = ele.replacingOccurrences(of: "\"", with: "")
//            let infoList = element.components(separatedBy: ",")
//            // let eName = infoList[0]
//            let code = infoList[1]
//            if let possibleMatch = (nameMappingList.first { $0.starts(with: code) }) {
//                let components = possibleMatch.components(separatedBy: ",")
//                let cName = components[1]
//                let eName = components[2]
//                let currency = UnitInfo(cName: cName, eName: eName, abbr: code, symbol: Utils.currencySymbol(by: code), image: Utils.countryFlag(by: code))
//                supportedCurrencies.append(currency)
//            }
//        }
//        print("‼️‼️‼️ count of supportedCurrencies: \(supportedCurrencies.count)")
//
//        guard !supportedCurrencies.isEmpty else { throw ServiceError.fetchingFailure }
//
//        return supportedCurrencies
//    }
//
//    private func fetchConversionRate() async throws -> [String:Double] {
//
//        let (data, response) = try await URLSession(configuration: .ephemeral).data(from: conversionRateURL)
//
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw ServiceError.fetchingFailure
//        }
//
//        guard let rawData = String(data: data, encoding: .utf8) else { throw ServiceError.fetchingFailure }
//
//        var conversionRates = rawData.components(separatedBy: .newlines)
//        conversionRates = conversionRates.filter { !$0.isEmpty }
//        // remove header of csv file
//        conversionRates.removeFirst()
//
//        let numberFormatter = NumberFormatter()
//        numberFormatter.decimalSeparator = ","
//
//        var conversionRateList = [String:Double]()
//        conversionRates.forEach { entry in
//            let infoList = entry.components(separatedBy: .whitespaces)
//            let currencyCode = infoList[0]
//            let rateToUSD = numberFormatter.number(from: infoList[1])?.doubleValue ?? 0
//            conversionRateList[currencyCode] = rateToUSD
//        }
//        print("‼️‼️‼️ count of conversionRateList: \(conversionRateList.count)")
//
//        guard !conversionRateList.isEmpty else { throw ServiceError.fetchingFailure }
//
//        return conversionRateList
//    }
//}
