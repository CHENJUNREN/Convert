//
//  GlobalState.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/1/31.
//

import Foundation
import Network

class GlobalState: ObservableObject {
    
    let conversionProcessor: ConversionProcessor = .shared
    
    let networkMonitor = NWPathMonitor()
    
    @Published var isConnectedToNetwork = true
    @Published var isInitializing = false
    @Published var isLoading = false
    @Published var isErrorPresented = false
    
    @Published var conversionUnits: [ConversionType:[UnitInfo]] = [:]
    @Published var servicesError: [ConversionType:ServiceError] = [:]
    
//    var unitsBackup: [ConversionType:[UnitInfo]]?
    
    init() {
        // check network connectivity
        setupNetworkMonitor()
        // init all conversion services
        Task {
            await initServices()
        }
    }
    
    @MainActor
    func initServices() async {
        // for animating purpose
        try? await Task.sleep(nanoseconds: 500_000_000)
        isInitializing = true
        isLoading = true
        await fetchAllConversionUnits()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
        
        if !servicesError.isEmpty {
            isErrorPresented = true
        } else {
            isInitializing = false
        }
    }
    
    @MainActor
    func reloadServices() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        await fetchAllConversionUnits()
        isLoading = false
        
        if servicesError.isEmpty {
            isInitializing = false
            isErrorPresented = false
        } else {
            isInitializing = true
            isErrorPresented = true
        }
    }
    
    func setupNetworkMonitor() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.isConnectedToNetwork = true
                }
            } else {
                DispatchQueue.main.async {
                    self?.isConnectedToNetwork = false
                }
            }
        }
        networkMonitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }
    
//    func searchUnits(in conversionType: ConversionType, by keyword: String) {
//        // search ends, restore list from backup
//        guard !keyword.isEmpty else {
//            restoreUnitsList(for: conversionType)
//            return
//        }
//        // restore list from backup before each search
//        restoreUnitsList(for: conversionType)
//        if let units = conversionUnits?[conversionType] {
//            let lowercased = keyword.lowercased()
//            conversionUnits?[conversionType] = units.filter { unit in
//                unit.cName.lowercased().contains(lowercased) ||
//                unit.eName?.lowercased().contains(lowercased) ?? false ||
//                unit.abbr?.lowercased().contains(lowercased) ?? false
//            }
//        }
//    }
    
//    func restoreUnitsList(for conversionType: ConversionType) {
//        conversionUnits?[conversionType] = unitsBackup?[conversionType]
//    }
    @MainActor
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
        
        // if no error, cancel network monitor
        if servicesError.isEmpty {
            networkMonitor.cancel()
        }
    }
}
