//
//  CurrencyConvertService.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-27.
//

import Foundation

class CurrencyConversionService: ConversionService {

    static let shared = CurrencyConversionService()
    
    private init() {}
    
    let type: ConversionType = .currency
    
    // base currency: USD (1 USD = ... unit)
    private var conversionTable: [UnitInfo:Double]?
    
    func convert(_ value: Double, from unit1: String, to unit2: String) async -> Result<ConversionResult, ServiceError> {
        
        if conversionTable == nil {
            do {
                try await setup()
            } catch(let err) {
                if let err = err as? ServiceError {
                    return .failure(err)
                } else {
                    return .failure(.systemFailure)
                }
            }
        }
        return convert(value: value, from: unit1, to: unit2)
    }
    
    func supportedUnits() async -> Result<[UnitInfo], ServiceError> {
        
        if conversionTable == nil {
            do {
                try await setup()
            } catch(let err) {
                if let err = err as? ServiceError {
                    return .failure(err)
                } else {
                    return .failure(.systemFailure)
                }
            }
        }
        return .success(conversionTable!.map { entry in entry.key })
    }
}


extension CurrencyConversionService {
    
    private var conversionRateURL: URL {
        URL(string: "https://api.exchangerate.host/latest?format=tsv&base=USD")!
    }
    
    private var supportedCurrenciesURL: URL {
        URL(string: "https://api.exchangerate.host/symbols?format=csv")!
    }
    
    private var currencyCodeToCNameMappingFileURL: URL {
        Bundle.main.url(forResource: "currencyCodeToName", withExtension: "csv")!
    }
    
    private var localBackupFileURL: URL {
        let cachesDirectory = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return cachesDirectory.appendingPathComponent("conversionTable.data")
    }
}


extension CurrencyConversionService {
    
    private func setup() async throws {
        
        async let supportedCurrenies = fetchSupportedCurrencies()
        async let conversionRates = fetchConversionRate()
        
        do {
            let (currencies, rates) = try await (supportedCurrenies, conversionRates)
            
            var conversionTable = [UnitInfo:Double]()
            currencies.forEach { unit in
                if let rate = rates[unit.abbr!] {
                    conversionTable[unit] = rate
                }
            }
            print("‼️‼️‼️ count of conversionTable: \(conversionTable.count)")
            self.conversionTable = conversionTable
            
            // save conversion table in cache
            Task(priority: .background) {
                Utils.saveFileLocally(in: localBackupFileURL, with: try! JSONEncoder().encode(self.conversionTable))
            }
        } catch(let error) {
            print("‼️‼️‼️ ERROR: \(error.localizedDescription)")
            // load backup if it was created within a day
            if let isBackupValid = Utils.isFileCreated(within: 1, for: localBackupFileURL) {
                if isBackupValid {
                    if let data = Utils.fetchFileLocally(for: localBackupFileURL) {
                        conversionTable = try! JSONDecoder().decode([UnitInfo:Double].self, from: data)
                        return
                    }
                }
            }
            // otherwise, rethrow error
            throw error
        }
    }
    
    
    private func fetchSupportedCurrencies() async throws -> [UnitInfo] {
        
        async let (data, response) = URLSession.shared.data(from: supportedCurrenciesURL)
        async let nameMapping = String(contentsOf: currencyCodeToCNameMappingFileURL)
        
        guard let httpResponse = try await response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServiceError.fetchingFailure
        }
        
        guard let currencies = String(data: try await data, encoding: .utf8) else {
            throw ServiceError.systemFailure
        }
        
        var nameMappingList = try await nameMapping.components(separatedBy: .newlines)
        nameMappingList = nameMappingList.filter { !$0.isEmpty }
        print("‼️‼️‼️ count of nameMappingList: \(nameMappingList.count)")
        
        var currenciesList = currencies.components(separatedBy: .newlines)
        currenciesList = currenciesList.filter { !$0.isEmpty }
        // remove header of csv file
        currenciesList.removeFirst()
        print("‼️‼️‼️ count of currenciesList: \(currenciesList.count)")
        
        var supportedCurrencies: [UnitInfo] = []
        currenciesList.forEach { ele in
            // remove quotation mark in csv file
            let element = ele.replacingOccurrences(of: "\"", with: "")
            let infoList = element.components(separatedBy: ",")
            // let eName = infoList[0]
            let code = infoList[1]
            if let possibleMatch = (nameMappingList.first { $0.starts(with: code) }) {
                let cName = possibleMatch.components(separatedBy: ",")[1]
                let eName = possibleMatch.components(separatedBy: ",")[2]
                let currency = UnitInfo(cName: cName, eName: eName, abbr: code, symbol: Utils.currencySymbol(by: code), image: Utils.countryFlag(by: code))
                supportedCurrencies.append(currency)
            }
        }
        print("‼️‼️‼️ count of supportedCurrencies: \(supportedCurrencies.count)")
        
        return supportedCurrencies
    }
    
    
    private func fetchConversionRate() async throws -> [String:Double] {
        
        let (data, response) = try await URLSession.shared.data(from: conversionRateURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServiceError.fetchingFailure
        }
        
        guard let rawData = String(data: data, encoding: .utf8) else { throw ServiceError.systemFailure }
        
        var conversionRates = rawData.components(separatedBy: .newlines)
        conversionRates = conversionRates.filter { !$0.isEmpty }
        // remove header of csv file
        conversionRates.removeFirst()
        
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = ","
        
        var conversionRateList = [String:Double]()
        conversionRates.forEach { entry in
            let infoList = entry.components(separatedBy: .whitespaces)
            let currencyCode = infoList[0]
            let rateToUSD = numberFormatter.number(from: infoList[1])?.doubleValue ?? 0
            conversionRateList[currencyCode] = rateToUSD
        }
        print("‼️‼️‼️ count of conversionRateList: \(conversionRateList.count)")
        
        return conversionRateList
    }
    
    
    private func convert(value: Double, from unit1: String, to unit2: String) -> Result<ConversionResult, ServiceError> {
        
        guard let conversionTable = self.conversionTable else { fatalError("Impossible state!") }
        
        guard let fromUnit = (conversionTable.first { $0.key.abbr! == unit1.uppercased() }?.key) else { return .failure(.conversionFailure) }
        
        guard let toUnit = (conversionTable.first { $0.key.abbr! == unit2.uppercased() }?.key) else { return .failure(.conversionFailure) }
        
        let valueToBase = value / conversionTable[fromUnit]!
        let baseToTarget = valueToBase * conversionTable[toUnit]!
        
        return .success(ConversionResult(type: type, fromValue: value.description, fromUnit: fromUnit, toValue: baseToTarget, toUnit: toUnit))
    }
    
//    private func fetchConversionRate() async {
//
//        var data: Data?
//        var localDataExistedButInvalid = false
//
//        // check if data was previous saved in local file system and is not outdated (tolerance: 1 days)
//        if let result = Utils.isFileCreated(within: 1, for: Self.localFileName) {
//            if result == true {
//                print("‼️‼️‼️ Local data is valid, fetching local data...")
//                data = Utils.fetchFileLocally(for: Self.localFileName)
//            } else {
//                localDataExistedButInvalid = true
//            }
//        }
//
//        // check if fetching local data is successful, otherwise fetch from remote server
//        if data == nil {
//            print("‼️‼️‼️ Local data doesen't exit or is outdated, or fetching failed, fetching data from remote server...")
//            let url = URL(string: Self.baseURL + "/single" + "?currency=CNY&appkey=\(Self.apikey)")!
//            do {
//                let (dataFromServer, response) = try await URLSession.shared.data(from: url)
//                if (response as? HTTPURLResponse)?.statusCode != 200 {
//                    throw ServiceError.fetchingFailed
//                }
//
//                var result = parseJsonData(dataFromServer)
//                print(result.count)
//                if result.isEmpty {
//                    throw ServiceError.fetchingFailed
//                }
//                // adding base currency to result
//                result[UnitInfo(cName: "人民币", abbr: "CNY", symbol: Utils.currencySymbol(by: "CNY"), image: Utils.countryFlag(by: "CNY"))] = 1
//
//                print("‼️‼️‼️ Fetching remote data succeeded! Saving data to local file system...")
//                Utils.saveFileLocally(for: Self.localFileName, with: try! JSONEncoder().encode(result))
//                conversionTable = result
//                status = .online
//                return
//            } catch(let err) {
//                // if local data exists but is invalid, try fetch it, otherwise return error
//                if localDataExistedButInvalid {
//                    data = Utils.fetchFileLocally(for: Self.localFileName)
//                }
//                if data == nil {
//                    if let error = err as? ServiceError, error == .fetchingFailed {
//                        status = .offline(.fetchingFailed)
//                        return
//                    } else {
//                        status = .offline(.systemFailed)
//                        return
//                    }
//                }
//            }
//        }
//
//        // data != nil
//        print("‼️‼️‼️ Fetching local data succeeded!")
//        conversionTable = try! JSONDecoder().decode([UnitInfo:Double].self, from: data!)
//        status = .online
//
//    }
}
