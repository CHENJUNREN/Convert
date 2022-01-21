//
//  HomeViewModel.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-27.
//

import Foundation

@MainActor
class MasterViewModel: ObservableObject {
    
    init() {
        Task {
            await fetchAllConversionUnits()
        }
    }
    
    // MARK: - Model
    
    let conversionProcessor: ConversionProcessor = ConversionProcessor.shared
    
    //  MARK: - MainView
    
    @Published var conversionResult: ConversionResult?
    
    @Published var conversionError: ServiceError?
    
    func fetchConversionResult(for query: String) async {
        conversionError = nil
        switch await conversionProcessor.conversionResult(for: query) {
        case .failure(let error):
            conversionError = error
        case .success(let result):
            conversionResult = result
        }
    }
    
    // MARK: - DocView
    
    @Published var conversionUnits: [ConversionType:[UnitInfo]]?
    
    var servicesError: [ConversionType:ServiceError]?
    
    var unitsBackup: [ConversionType:[UnitInfo]]?
    
    func searchUnits(in conversionType: ConversionType, by keyword: String) {
        // search ends, restore list from backup
        guard !keyword.isEmpty else {
            restoreUnitsList(for: conversionType)
            return
        }
        // restore list from backup before each search
        restoreUnitsList(for: conversionType)
        if let units = conversionUnits?[conversionType] {
            let lowercased = keyword.lowercased()
            conversionUnits?[conversionType] = units.filter { unit in
                unit.cName.lowercased().contains(lowercased) ||
                unit.eName?.lowercased().contains(lowercased) ?? false ||
                unit.abbr?.lowercased().contains(lowercased) ?? false
            }
        }
    }
    
    func restoreUnitsList(for conversionType: ConversionType) {
        conversionUnits?[conversionType] = unitsBackup?[conversionType]
    }
    
    func fetchAllConversionUnits() async {
        let fetchResult = await conversionProcessor.supportedConversionAndUnits()
        
        var servicesWithoutError = [ConversionType:[UnitInfo]]()
        var servicesWithError = [ConversionType: ServiceError]()
        for (type, result) in fetchResult {
            switch result {
            case .success(var units):
                if (type == .currency) {
                    // sort list by currency code
                    units = units.sorted(by: { left, right in
                        if left.abbr!.compare(right.abbr!) == .orderedAscending {
                            return true
                        }
                        return false
                    })
                }
                servicesWithoutError[type] = units
            case .failure(let error):
                servicesWithError[type] = error
            }
        }
        conversionUnits = servicesWithoutError
        servicesError = servicesWithError
        unitsBackup = conversionUnits
    }
}
