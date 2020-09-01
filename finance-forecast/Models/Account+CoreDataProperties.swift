//
//  Account+CoreDataProperties.swift
//  finance-forecast
//
//  Created by Jamie Willis on 01/09/2020.
//  Copyright © 2020 Jamie Willis. All rights reserved.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var name: String?
    @NSManaged public var balance: Double
    @NSManaged public var credit: Bool
}
