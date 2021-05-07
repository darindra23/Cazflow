//
//  User+CoreDataProperties.swift
//  Cazflow
//
//  Created by Darindra R on 05/05/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var balance: Int64
    @NSManaged public var name: String?
    @NSManaged public var budget: NSSet?
    @NSManaged public var cashflow: NSSet?

}

// MARK: Generated accessors for budget
extension User {

    @objc(addBudgetObject:)
    @NSManaged public func addToBudget(_ value: Budget)

    @objc(removeBudgetObject:)
    @NSManaged public func removeFromBudget(_ value: Budget)

    @objc(addBudget:)
    @NSManaged public func addToBudget(_ values: NSSet)

    @objc(removeBudget:)
    @NSManaged public func removeFromBudget(_ values: NSSet)

}

// MARK: Generated accessors for cashflow
extension User {

    @objc(addCashflowObject:)
    @NSManaged public func addToCashflow(_ value: Cashflow)

    @objc(removeCashflowObject:)
    @NSManaged public func removeFromCashflow(_ value: Cashflow)

    @objc(addCashflow:)
    @NSManaged public func addToCashflow(_ values: NSSet)

    @objc(removeCashflow:)
    @NSManaged public func removeFromCashflow(_ values: NSSet)

}

extension User : Identifiable {

}
