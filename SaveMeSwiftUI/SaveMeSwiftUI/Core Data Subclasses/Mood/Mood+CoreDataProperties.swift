//
//  Mood+CoreDataProperties.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 28/02/2021.
//
//

import Foundation
import CoreData

extension Mood {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mood> {
        return NSFetchRequest<Mood>(entityName: "Mood")
    }

    @NSManaged public var value: Double
    @NSManaged public var emoji: Data
    @NSManaged public var date: String
    @NSManaged public var time: String
}

extension Mood : Identifiable {
}
