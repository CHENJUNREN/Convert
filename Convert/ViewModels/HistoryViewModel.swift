//
//  HistoryViewModel.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/14.
//

import Foundation
import CoreData

class HistoryViewModel: ObservableObject {
    
    let persistenceController = PersistenceController.shared
    
    func generateCopyString(value: String, unit: Unit, type: ConversionType) -> String {
        let copyAlongWithUnit = UserDefaults.standard.bool(forKey: "copyAlongWithUnit")
        let copyUnitInChinese = UserDefaults.standard.bool(forKey: "copyUnitInChinese")
        let currencyCopyFormat = UserDefaults.standard.integer(forKey: "currencyCopyFormat")
        
        if copyAlongWithUnit {
            let code = " " + (copyUnitInChinese ? unit.name! : unit.symbol!)
            
            if type == .currency && (currencyCopyFormat == 0 || currencyCopyFormat == 2) {
                let prefixSymbol = unit.prefixSymbol == nil ? "" : "\(unit.prefixSymbol!) "
                return prefixSymbol + value + (currencyCopyFormat == 0 ? code : "")
            } else {
                return value + code
            }
        } else {
            return value
        }
    }
    
    func delete(_ conversion: Conversion) {
        let objectID = conversion.objectID
        persistenceController.enqueue { context in
            let managedObject = context.object(with: objectID)
            if let conver = managedObject as? Conversion,
               let record = conver.belongTo,
               record.unwrappedConversions.count == 1,
               record.unwrappedConversions.first!.objectID == objectID
            {
                context.delete(record)
            } else {
                context.delete(managedObject)
            }
        }
    }
    
    func deleteHistory() {
        persistenceController.enqueue { context in
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            if let records = try? context.fetch(fetchRequest) {
                for record in records {
                    context.delete(record)
                }
            }
        }
    }
    
}
