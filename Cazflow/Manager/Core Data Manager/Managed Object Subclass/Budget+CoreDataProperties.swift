//
//  Budget+CoreDataProperties.swift
//  Cazflow
//
//  Created by Darindra R on 05/05/21.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var balance: Int64
    @NSManaged public var budget: Int64
    @NSManaged public var budgetDescription: String?
    @NSManaged public var limit: Int64
    @NSManaged public var name: String?
    @NSManaged public var cashflow: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for cashflow
extension Budget {

    @objc(addCashflowObject:)
    @NSManaged public func addToCashflow(_ value: Cashflow)

    @objc(removeCashflowObject:)
    @NSManaged public func removeFromCashflow(_ value: Cashflow)

    @objc(addCashflow:)
    @NSManaged public func addToCashflow(_ values: NSSet)

    @objc(removeCashflow:)
    @NSManaged public func removeFromCashflow(_ values: NSSet)

}

extension Budget : Identifiable {

}
