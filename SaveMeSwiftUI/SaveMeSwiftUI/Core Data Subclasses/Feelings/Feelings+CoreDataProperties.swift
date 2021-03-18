//
//  Feelings+CoreDataProperties.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 06/03/2021.
//
//

import Foundation
import CoreData

extension Feelings {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feelings> {
        return NSFetchRequest<Feelings>(entityName: "Feelings")
    }

    @NSManaged public var content: String
    @NSManaged public var date: String
    @NSManaged public var time: String
}

extension Feelings : Identifiable {
}
