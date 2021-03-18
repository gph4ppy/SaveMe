//
//  Diary+CoreDataProperties.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/03/2021.
//
//

import Foundation
import CoreData

extension Diary {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var date: String
    @NSManaged public var time: String
    @NSManaged public var content: String
}

extension Diary : Identifiable {
}
