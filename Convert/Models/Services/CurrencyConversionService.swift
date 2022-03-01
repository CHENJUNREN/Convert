//
//  CurrencyConversionService.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-27.
//

import Foundation

class CurrencyConversionService: ConversionService {

    static let shared = CurrencyConversionService()
    
    let type: ConversionType = .currency
    
    private var conversionTable: [UnitInfo:Double] = [:]
    
    private init() {}
    
    func convert(_ value: Double, from unit1: String, to unit2: String) -> Result<ConversionResult, ServiceError> {
        
        guard !conversionTable.isEmpty else { return .failure(.conversionFailure) }
        
        guard let fromUnit = (conversionTable.first { $0.key.abbr! == unit1.uppercased() }?.key) else { return .failure(.conversionFailure) }
        
        guard let toUnit = (conversionTable.first { $0.key.abbr! == unit2.uppercased() }?.key) else { return .failure(.conversionFailure) }
        
        let valueToBase = value / conversionTable[fromUnit]!
        let baseToTarget = valueToBase * conversionTable[toUnit]!
        
        return .success(ConversionResult(type: type, fromValue: value.description, fromUnit: fromUnit, toValue: baseToTarget, toUnit: toUnit))
    }
    
    func supportedUnits() async -> Result<[UnitInfo], ServiceError> {
        if conversionTable.isEmpty {
            do {
                try await setup()
            } catch {
                print("‼️‼️‼️ ERROR: \(error.localizedDescription)")
                return .failure(.fetchingFailure)
            }
        }
        return .success(conversionTable.map { entry in entry.key })
    }
}

extension CurrencyConversionService {
    
    private var baseCurrency: String { "eur" }
    
    private var currencyCodeToNameMappingFileURL: URL {
        Bundle.main.url(forResource: "currencyCodeToName", withExtension: "csv")!
    }
    
    private var localBackupFileURL: URL {
        let cachesDirectory = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return cachesDirectory.appendingPathComponent("conversionTable.data")
    }
    
    private func setup() async throws {
        
        // load backup if it was created within today
        if let isBackupValid = Utils.isFileCreatedRecently(fileURL: localBackupFileURL),
           isBackupValid,
           let data = Utils.fetchFileLocally(for: localBackupFileURL),
           let conversionData = try? JSONDecoder().decode([UnitInfo:Double].self, from: data)
        {
            conversionTable = conversionData
            return
        }
        
        // otherwise, fetch data from remote server
        async let supportedCurrencies = fetchSupportedCurrencies()
        async let conversionRates = fetchConversionRate()
        
        let (currencies, rates) = try await (supportedCurrencies, conversionRates)
        
        var conversionTable = [UnitInfo:Double]()
        currencies.forEach { currency in
            if let rate = rates[currency.abbr!] {
                conversionTable[currency] = rate
            }
        }
        print("‼️‼️‼️ count of conversionTable: \(conversionTable.count)")
        
        if conversionTable.isEmpty {
            throw ServiceError.fetchingFailure
        } else {
            self.conversionTable = conversionTable
        }
        
        // save conversion table in cache
        Task(priority: .background) {
            if let data = try? JSONEncoder().encode(self.conversionTable) {
                Utils.saveFileLocally(in: localBackupFileURL, with: data)
            }
        }
    }
}

extension CurrencyConversionService {
    
    private var conversionRateURL: URL {
        URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/\(baseCurrency).json")!
    }
    
    private func fetchSupportedCurrencies() throws -> [UnitInfo] {
        
        let nameMapping = try String(contentsOf: currencyCodeToNameMappingFileURL)
        
        let nameMappingList = nameMapping
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
        
        let supportedCurrencies = nameMappingList.map { (entry) -> UnitInfo in
            let components = entry.components(separatedBy: ",")
            let code = components[0]
            let cName = components[1]
            let eName = components[2]
            return UnitInfo(cName: cName, eName: eName, abbr: code, symbol: Utils.currencySymbol(by: code), image: Utils.countryFlag(by: code))
        }
        print("‼️‼️‼️ count of supportedCurrencies: \(supportedCurrencies.count)")
        
        guard !supportedCurrencies.isEmpty else { throw ServiceError.fetchingFailure }
        
        return supportedCurrencies
    }
    
    private func fetchConversionRate() async throws -> [String:Double] {
        
        let (data, response) = try await URLSession(configuration: .ephemeral).data(from: conversionRateURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServiceError.fetchingFailure
        }
        
        var conversionRateList = [String : Double]()
        if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
            if let dics = json[baseCurrency] as? [String : Double] {
                let temp = dics.map { entry in
                    (key: entry.key.uppercased(), value: entry.value)
                }
                conversionRateList = Dictionary(uniqueKeysWithValues: temp)
            }
        }
        print("‼️‼️‼️ count of conversionRateList: \(conversionRateList.count)")
        
        guard !conversionRateList.isEmpty else { throw ServiceError.fetchingFailure }
        
        return conversionRateList
    }
}
