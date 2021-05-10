//
//  Cashflow+CoreDataProperties.swift
//  Cazflow
//
//  Created by Darindra R on 05/05/21.
//
//

import Foundation
import CoreData


extension Cashflow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cashflow> {
        return NSFetchRequest<Cashflow>(entityName: "Cashflow")
    }

    @NSManaged public var date: Date?
    @NSManaged public var type: String?
    @NSManaged public var image: String?
    @NSManaged public var nominal: Int64
    @NSManaged public var note: String?
    @NSManaged public var source: String?
    @NSManaged public var user: User?
    @NSManaged public var budget: Budget?

}

extension Cashflow: Identifiable {

}

extension Cashflow {
    @objc var getDateOnly: String { get {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyy"

        return formatter.string(from: self.date!)
    } }
}


