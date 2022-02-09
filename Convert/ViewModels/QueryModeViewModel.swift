//
//  MainViewModel.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-27.
//

import Foundation

@MainActor
class QueryModeViewModel: ObservableObject {
    
    let conversionProcessor: ConversionProcessor = .shared
    
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
}
