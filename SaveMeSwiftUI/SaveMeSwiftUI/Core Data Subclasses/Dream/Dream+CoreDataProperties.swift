//
//  Dream+CoreDataProperties.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 04/03/2021.
//
//

import Foundation
import CoreData

extension Dream {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dream> {
        return NSFetchRequest<Dream>(entityName: "Dream")
    }

    @NSManaged public var content: String
    @NSManaged public var date: String
    @NSManaged public var time: String
}

extension Dream : Identifiable {
}
