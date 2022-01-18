//
//  DocView.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-26.
//

import SwiftUI

struct DocView: View {
    
    @EnvironmentObject var viewModel: MasterViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var searchBarText = ""
//    @State private var selectedConversionType: ConversionType = .length
    @AppStorage(wrappedValue: ConversionType.length, "selectedTab") var selectedConversionType
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                NoticeBox()
                
                Picker("支持的转换类型和单位", selection: $selectedConversionType) {
                    ForEach(ConversionType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if viewModel.conversionUnits != nil {
                    TabView(selection: $selectedConversionType) {
                        ForEach(ConversionType.allCases, id: \.self) { type in
                            SupportedUnitsGallery(type: type, units: viewModel.conversionUnits![type] ?? [], error: viewModel.servicesError![type])
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
        .onChange(of: searchBarText) { keyword in
            viewModel.searchUnits(in: selectedConversionType, by: keyword)
        }
        .onChange(of: selectedConversionType) { [selectedConversionType] _ in
            if !searchBarText.isEmpty {
                searchBarText = ""
                Task {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    viewModel.restoreUnitsList(for: selectedConversionType)
                }
            }
        }
    }
}

struct DocView_Previews: PreviewProvider {
    static var previews: some View {
        DocView()
    }
}
