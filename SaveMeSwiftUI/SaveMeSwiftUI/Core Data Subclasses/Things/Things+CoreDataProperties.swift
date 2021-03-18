//
//  Things+CoreDataProperties.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/03/2021.
//
//

import Foundation
import CoreData

extension Things {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Things> {
        return NSFetchRequest<Things>(entityName: "Things")
    }

    @NSManaged public var date: String
    @NSManaged public var time: String
    @NSManaged public var content: String
}

extension Things : Identifiable {
}
