//
//  CheatSheetView.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-26.
//

import SwiftUI

struct CheatSheetView: View {
    @EnvironmentObject var globalState: GlobalState
    
    @Binding var selectedConversionType: ConversionType
    
    @State private var searchBarText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            typePicker
            
            if !globalState.conversionUnits.isEmpty {
                unitsTabView
            } else {
                ProgressView("载入中")
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .searchable(text: $searchBarText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索(中英文或 Emoji 国旗)")
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        .onChange(of: selectedConversionType) { _ in
            if !searchBarText.isEmpty {
                searchBarText = ""
            }
        }
    }
    
    var typePicker: some View {
        Picker("支持的转换类型和单位", selection: $selectedConversionType) {
            ForEach(ConversionType.allCases, id: \.self) { type in
                Text(type.rawValue)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    var unitsTabView: some View {
        TabView(selection: $selectedConversionType) {
            ForEach(ConversionType.allCases, id: \.self) { type in
                UnitGallery(
                    type: type,
                    units: filteredConversionUnits(for: selectedConversionType, by: searchBarText)[type] ?? [],
                    error: globalState.servicesError[type]
                )
                    .tag(type)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    func filteredConversionUnits(for type: ConversionType, by keyword: String) -> [ConversionType:[UnitInfo]] {
        if keyword.isEmpty { return globalState.conversionUnits }
        
        var result = globalState.conversionUnits
        if let units = result[type] {
            result[type] = units.filter { unit in
                unit.cName.localizedCaseInsensitiveContains(keyword) ||
                unit.abbr?.localizedCaseInsensitiveContains(keyword) ?? false ||
                unit.image?.localizedCaseInsensitiveContains(keyword) ?? false
            }
        }
        return result
    }
}
