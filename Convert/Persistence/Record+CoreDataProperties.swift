//
//  Record+CoreDataProperties.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/15.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var conversionType: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var conversions: NSSet?

    public var unwrappedConversions: [Conversion] {
        let set = conversions as? Set<Conversion> ?? []
        return set.sorted { first, second in
            first.createdAt! > second.createdAt!
        }
    }
    
    convenience init(context: NSManagedObjectContext, type: String) {
        self.init(context: context)
        conversionType = type
        conversions = []
        updatedAt = Date.now
    }
    
}

// MARK: Generated accessors for conversions
extension Record {

    @objc(addConversionsObject:)
    @NSManaged public func addToConversions(_ value: Conversion)

    @objc(removeConversionsObject:)
    @NSManaged public func removeFromConversions(_ value: Conversion)

    @objc(addConversions:)
    @NSManaged public func addToConversions(_ values: NSSet)

    @objc(removeConversions:)
    @NSManaged public func removeFromConversions(_ values: NSSet)

}

extension Record : Identifiable {

}
