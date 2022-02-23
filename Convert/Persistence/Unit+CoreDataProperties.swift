//
//  Unit+CoreDataProperties.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/23.
//
//

import Foundation
import CoreData


extension Unit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Unit> {
        return NSFetchRequest<Unit>(entityName: "Unit")
    }

    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var prefixSymbol: String?
    @NSManaged public var from: NSSet?
    @NSManaged public var to: NSSet?
    
    convenience init(context: NSManagedObjectContext, name: String, symbol: String, prefixSymbol: String?) {
        self.init(context: context)
        self.name = name
        self.symbol = symbol
        self.prefixSymbol = prefixSymbol
    }
    
}

// MARK: Generated accessors for from
extension Unit {

    @objc(addFromObject:)
    @NSManaged public func addToFrom(_ value: Conversion)

    @objc(removeFromObject:)
    @NSManaged public func removeFromFrom(_ value: Conversion)

    @objc(addFrom:)
    @NSManaged public func addToFrom(_ values: NSSet)

    @objc(removeFrom:)
    @NSManaged public func removeFromFrom(_ values: NSSet)

}

// MARK: Generated accessors for to
extension Unit {

    @objc(addToObject:)
    @NSManaged public func addToTo(_ value: Conversion)

    @objc(removeToObject:)
    @NSManaged public func removeFromTo(_ value: Conversion)

    @objc(addTo:)
    @NSManaged public func addToTo(_ values: NSSet)

    @objc(removeTo:)
    @NSManaged public func removeFromTo(_ values: NSSet)

}

extension Unit : Identifiable {

}
