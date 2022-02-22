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
