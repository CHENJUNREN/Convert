//
//  SupportedUnitsGallery.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-01.
//

import SwiftUI
import Network

struct SupportedUnitsGallery: View {
    let type: ConversionType
    let units: [UnitInfo]
    let error: ServiceError?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if type == .currency {
                let sortedUnits = prepareCurrencyList()
                
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                    ForEach(sortedUnits.indices, id: \.self) { index in
                        Section {
                            ForEach(sortedUnits[index].1, id: \.self) { unit in
                                CurrencyUnitCell(unit: unit)
                            }
                        } header: {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(sortedUnits[index].0)
                                        .padding(.horizontal, 25)
                                        .padding(.vertical, 5)
                                        .font(.subheadline.bold().monospaced())
                                    
                                    Spacer()
                                }
                                
                                Divider()
                                    .padding(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: .systemBackground))
                        }
                    }
                }
            } else {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2),
                    spacing: 10
                ) {
                    ForEach(units, id: \.self) { unit in
                        NormalUnitCell(unit: unit)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
        .overlay {
            if error != nil {
                VStack(spacing: 5) {
                    Label(error!.localizedDescription, systemImage: "xmark.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.subheadline)
                    
                    Text("可在设置中重新加载")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            }
        }
    }
    
    func prepareCurrencyList() -> [(String, [UnitInfo])] {
        var result = [(String, [UnitInfo])]()
        
        guard !units.isEmpty else { return result }
        
        // most frequently used currencies
        let codes = ["USD", "EUR", "JPY", "GBP", "AUD", "CAD", "CHF", "CNY", "SEK", "MXN", "NZD", "SGD", "HKD", "NOK", "KRW", "TRY", "INR", "RUB", "BRL", "ZAR", "DKK", "PLN", "TWD", "THB", "MYR"]
        
        var mostFrequent = [UnitInfo]()
        codes.forEach { code in
            if let match = (units.first { $0.abbr == code }) {
                mostFrequent.append(match)
            }
        }
        
        if !mostFrequent.isEmpty {
            result.append(("常用", mostFrequent))
        }
        
        // sort list by currency code
        // filter out most frequently used currencies
        let sortedUnits = units
            .sorted { $0.abbr! < $1.abbr! }
            .filter { !mostFrequent.contains($0) }
        
        if !sortedUnits.isEmpty {
            var start = 0
            var startChar = sortedUnits[start].abbr!.first!
            for i in 1..<sortedUnits.endIndex {
                let temChar = sortedUnits[i].abbr!.first!
                if temChar != startChar {
                    result.append((String(startChar), Array(sortedUnits[start..<i])))
                    start = i
                    startChar = temChar
                }
            }
            result.append((String(startChar), Array(sortedUnits[start..<sortedUnits.endIndex])))
        }
        
        return result
    }
}

struct CurrencyUnitCell: View {
    let unit: UnitInfo
    
    var body: some View {
        HStack(spacing: 15) {
            Text(unit.image ?? "🌏")
                .font(.title2)
            
            HStack {
                Text(unit.cName)
                    .font(.body.weight(.light))
                
                Spacer()
                
                Text(unit.abbr!)
                    .font(.headline.monospaced())
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color(uiColor: .systemBackground))
        .contextMenu {
            Button {
                UIPasteboard.general.string = unit.abbr!
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            } label: {
                Label("拷贝 \"\(unit.abbr!)\"", systemImage: "arrow.right.doc.on.clipboard")
            }
        }
    }
}

struct NormalUnitCell: View {
    let unit: UnitInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(unit.cName)
                    .font(.subheadline.weight(.light))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                
                Spacer()
                
                if let abbr = unit.abbr {
                    Text(abbr)
                        .font(.headline.monospaced())
                }
            }
            
            //            Text(unit.eName ?? " ")
            //                .font(.caption)
            //                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(15)
        .contextMenu {
            if let abbr = unit.abbr {
                Button {
                    UIPasteboard.general.string = abbr
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } label: {
                    Label("拷贝 \"\(abbr)\"", systemImage: "arrow.right.doc.on.clipboard")
                }
            }
            Button {
                UIPasteboard.general.string = unit.cName
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            } label: {
                Label("拷贝 \"\(unit.cName)\"", systemImage: "arrow.right.doc.on.clipboard")
            }
        }
    }
}

//HStack(alignment: .center) {
//    Text(unit.image ?? "🌏")
//        .font(.title2)
//
//    VStack(alignment: .leading, spacing: 2) {
//        HStack {
//            Text(unit.cName)
//            Divider()
//            Text(unit.abbr!)
//                .font(.headline)
//                .foregroundColor(.secondary)
//        }
//
//        Text(unit.eName!)
//            .font(.caption)
//            .foregroundColor(.secondary)
//    }
//}
