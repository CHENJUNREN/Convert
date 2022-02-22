//
//  GlobalState.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/1/31.
//

import SwiftUI
import Network

class GlobalState: ObservableObject {
    
    let conversionProcessor: ConversionProcessor = .shared
    
    let networkMonitor = NWPathMonitor()
    
    @Published var isConnectedToNetwork = true
    @Published var isLoading = false
    @Published var isErrorPresented = false
    @Published var showCopySuccess = false
    @Published var showLoadingSuccess = false
    
    @Published var conversionUnits: [ConversionType:[UnitInfo]] = [:]
    @Published var servicesError: [ConversionType:ServiceError] = [:]
    
    init() {
        // check network connectivity
        setupNetworkMonitor()
        // init all conversion services
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            await initServices()
        }
    }
    
    @MainActor
    func initServices() async {
        // for animating purpose
        withAnimation {
            isLoading = true
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        await fetchAllConversionUnits()
        
        withAnimation {
            isLoading = false
        }
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if !servicesError.isEmpty {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            withAnimation {
                isErrorPresented = true
            }
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            withAnimation {
                isErrorPresented = false
                showLoadingSuccess = true
            }
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

    @MainActor
    func fetchAllConversionUnits() async {
        let fetchResult = await conversionProcessor.supportedConversionAndUnits()
        
        var servicesWithoutError = [ConversionType:[UnitInfo]]()
        var servicesWithError = [ConversionType: ServiceError]()
        for (type, result) in fetchResult {
            switch result {
            case .success(let units):
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
