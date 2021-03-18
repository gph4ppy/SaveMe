//
//  Positive+CoreDataProperties.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/03/2021.
//
//

import Foundation
import CoreData

extension Positive {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Positive> {
        return NSFetchRequest<Positive>(entityName: "Positive")
    }

    @NSManaged public var content: String
}

extension Positive : Identifiable {
}
