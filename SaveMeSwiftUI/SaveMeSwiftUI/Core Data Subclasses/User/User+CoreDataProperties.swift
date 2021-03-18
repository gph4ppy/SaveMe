//
//  User+CoreDataProperties.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 28/02/2021.
//
//

import Foundation
import CoreData

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatar: Data
}

extension User : Identifiable {
}
