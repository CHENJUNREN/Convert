//
//  Conversion+CoreDataProperties.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/13.
//
//

import Foundation
import CoreData


extension Conversion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversion> {
        return NSFetchRequest<Conversion>(entityName: "Conversion")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var fromValue: String?
    @NSManaged public var id: UUID?
    @NSManaged public var toValue: Double
    @NSManaged public var belongTo: Record?
    @NSManaged public var from: Unit?
    @NSManaged public var to: Unit?
    
    convenience init(context: NSManagedObjectContext, fromValue: String, toValue: Double, from: Unit, to: Unit) {
        self.init(context: context)
        createdAt = Date.now
        id = UUID()
        self.fromValue = fromValue
        self.toValue = toValue
        self.from = from
        self.to = to
    }

}

extension Conversion : Identifiable {

}
