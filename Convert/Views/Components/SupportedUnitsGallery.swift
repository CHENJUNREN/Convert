//
//  SupportedUnitsGallery.swift
//  Convert
//
//  Created by Chenjun Ren on 2022-01-01.
//

import SwiftUI

struct SupportedUnitsGallery: View {

    let type: ConversionType
    let units: [UnitInfo]
    let error: ServiceError?
    
    var body: some View {
        Group {
            if type == .currency {
                List(units, id: \.self) { unit in
                    CurrencyUnitCell(unit: unit)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2),
                        spacing: 10
                    ) {
                        ForEach(units, id: \.self) { unit in
                            NormalUnitCell(unit: unit)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .overlay {
            if error != nil {
                GroupBox {
                    Label(error!.localizedDescription, systemImage: "xmark.octagon")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
            }
        }
    }
}

//List(units, id: \.self) { unit in
//    Group {
//        if type == .currency {
//            CurrencyUnitCell(unit: unit)
//        } else {
//            NormalUnitCell(unit: unit)
//        }
//    }
//    .listRowSeparator(.hidden)
//}
//.listStyle(.plain)


struct NormalUnitCell: View {
    let unit: UnitInfo

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(unit.cName)
                        .font(.callout)

                    if let abbr = unit.abbr {
                        Divider()
                        Text(abbr)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }

//                Text(unit.eName ?? " ")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
            }
        }
        .contextMenu {
            if let abbr = unit.abbr {
                Button {
                    UIPasteboard.general.string = abbr
                } label: {
                    Label("拷贝 \"\(abbr)\"", systemImage: "arrow.right.doc.on.clipboard")
                }
            }
            Button {
                UIPasteboard.general.string = unit.cName
            } label: {
                Label("拷贝 \"\(unit.cName)\"", systemImage: "arrow.right.doc.on.clipboard")
            }
        }
    }
}

struct CurrencyUnitCell: View {
    let unit: UnitInfo
    
    var body: some View {
        HStack(alignment: .center) {
            Text(unit.image ?? "🌏")
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(unit.cName)
                    Divider()
                    Text(unit.abbr!)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
//                Text(unit.eName!)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
            }
        }
        .contextMenu {
            Button {
                UIPasteboard.general.string = unit.abbr!
            } label: {
                Label("拷贝 \"\(unit.abbr!)\"", systemImage: "arrow.right.doc.on.clipboard")
            }
        }
    }
}

//struct NormalUnitCell: View {
//    let unit: UnitInfo
//
//    var body: some View {
//        HStack {
//            Text(unit.cName)
//
//            if let eName = unit.eName {
//                Divider()
//                Text(eName)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//
//            if let abbr = unit.abbr {
//                Divider()
//                Text(abbr)
//                    .font(.headline)
//            }
//        }
//        .contextMenu {
//            if let abbr = unit.abbr {
//                Button {
//                    UIPasteboard.general.string = abbr
//                } label: {
//                    Label("拷贝 \"\(abbr)\"", systemImage: "arrow.right.doc.on.clipboard")
//                }
//            }
//            Button {
//                UIPasteboard.general.string = unit.cName
//            } label: {
//                Label("拷贝 \"\(unit.cName)\"", systemImage: "arrow.right.doc.on.clipboard")
//            }
//        }
//    }
//}






