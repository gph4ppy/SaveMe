//
//  SaveMeApp.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 26/02/2021.
//

import SwiftUI

@main
struct SaveMeApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
