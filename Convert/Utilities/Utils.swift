//
//  Utils.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-29.
//

import Foundation

struct Utils {
    
    static let locales = Locale.availableIdentifiers.map { Locale(identifier: $0) }
    
    
    static func currencySymbol(by currencyCode: String) -> String? {
        let locale = locales.first { $0.currencyCode == currencyCode }
        return locale?.currencySymbol
    }

    
    static func countryFlag(by currencyCode: String) -> String? {
        // exception
        if currencyCode == "EUR" { return "🇪🇺" }
        if currencyCode == "BTC" { return nil }
        
        // check if there is a country of which country code equals the first two letters of currency code
        let possibleCountryCode = String(currencyCode[..<currencyCode.index(currencyCode.endIndex, offsetBy: -1)])
        let country = locales.first { $0.regionCode == possibleCountryCode }
        guard country != nil else { return nil }
        
        // calculate emoji country flag unicode based on country code
        let base: UInt32 = 127397
        var result = ""
        for v in possibleCountryCode.unicodeScalars {
            result.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(result)
    }
    
    
    static func fetchFileLocally(for url: URL) -> Data? {
        print("‼️‼️‼️ Fetching local data on thread \(Thread.current.description)")
        return try? Data(contentsOf: url)
    }
    
    
    static func saveFileLocally(in url: URL, with data: Data) {
        do {
            print("‼️‼️‼️ Saving data on thread \(Thread.current.description)")
            try data.write(to: url, options: [.atomic, .completeFileProtection])
            print("‼️‼️‼️ Saving data succeeded!")
        } catch {
            print("‼️‼️‼️ Saving data failed. Doesn't matter 😂")
        }
    }
    
    
    static func getFileCreationDate(for url: URL) -> Date? {
        
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        
        let attributes = try! FileManager.default.attributesOfItem(atPath: url.path)
        
        guard let creationDate = attributes[.creationDate],
              let creationDate = creationDate as? NSDate else { return nil }
        
        return creationDate as Date
    }
    
    
    static func isFileCreated(within numOfDays: Int, for url: URL) -> Bool? {
        if let localDataCreationDate = Self.getFileCreationDate(for: url) {
            let timeIntervalInDays = -localDataCreationDate.timeIntervalSinceNow / (24 * 60 * 60)
            return timeIntervalInDays <= Double(numOfDays) ? true : false
        }
        return nil
    }
}
