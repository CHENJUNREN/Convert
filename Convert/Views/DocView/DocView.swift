//
//  DocView.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-26.
//

import SwiftUI

struct DocView: View {
    
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.dismiss) var dismiss
    
    @State private var searchBarText = ""
    @Binding var selectedConversionType: ConversionType
    @Binding var showNotice: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                NoticeBox(showNotice: $showNotice)
                
                Picker("支持的转换类型和单位", selection: $selectedConversionType) {
                    ForEach(ConversionType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
//                TagList(selectedConversionType: $selectedConversionType)
                
                if !globalState.conversionUnits.isEmpty {
                    TabView(selection: $selectedConversionType) {
                        ForEach(ConversionType.allCases, id: \.self) { type in
                            SupportedUnitsGallery(type: type,
                                                  units: filteredConversionUnits(for: selectedConversionType, by: searchBarText)[type] ?? [],
                                                  error: globalState.servicesError[type])
                                .tag(type)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                } else {
                    ProgressView("载入中")
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("使用指南")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle")
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .searchable(text: $searchBarText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索")
        .disableAutocorrection(true)
//        .onChange(of: searchBarText) { keyword in
//            viewModel.searchUnits(in: selectedConversionType, by: keyword)
//        }
//        .onChange(of: selectedConversionType) { [selectedConversionType] _ in
//            if !searchBarText.isEmpty {
//                searchBarText = ""
//                Task {
//                    try? await Task.sleep(nanoseconds: 1_000_000_000)
//                    viewModel.restoreUnitsList(for: selectedConversionType)
//                }
//            }
//        }
        .onChange(of: selectedConversionType) { _ in
            if !searchBarText.isEmpty {
                searchBarText = ""
            }
        }
    }
    
    func filteredConversionUnits(for type: ConversionType, by keyword: String) -> [ConversionType:[UnitInfo]] {
        if keyword.isEmpty { return globalState.conversionUnits }
        
        var result = globalState.conversionUnits
        if let units = result[type] {
            result[type] = units.filter { unit in
                unit.cName.localizedCaseInsensitiveContains(keyword) ||
                unit.eName?.localizedCaseInsensitiveContains(keyword) ?? false ||
                unit.abbr?.localizedCaseInsensitiveContains(keyword) ?? false
            }
        }
        return result
    }
}

struct DocView_Previews: PreviewProvider {
    static var previews: some View {
        DocView(selectedConversionType: Binding<ConversionType>.constant(.currency),
                showNotice: Binding<Bool>.constant(true))
    }
}
