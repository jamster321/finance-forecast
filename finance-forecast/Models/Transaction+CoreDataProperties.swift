//
//  Transaction+CoreDataProperties.swift
//  finance-forecast
//
//  Created by Jamie Willis on 30/08/2020.
//  Copyright © 2020 Jamie Willis. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var name: String
    @NSManaged public var date: Date
    @NSManaged public var amount: Double
    @NSManaged public var monthly: Bool
    @NSManaged public var complete: Bool
}
