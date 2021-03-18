//
//  StartView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 26/02/2021.
//

import SwiftUI
import CoreData

struct StartView: View {
    let userData = UserDataViewModel()
    let persistenceController = PersistenceController.shared
    @ObservedObject static var userData = UserDataViewModel()
    @AppStorage("DarkMode") var darkMode: Bool = userData.isDarkMode
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        if userData.isLogged {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    UserDefaults.standard.set(darkMode, forKey: "DarkMode")
                }
                .environment(\.colorScheme, darkMode ? .dark : .light)
        } else {
            WelcomeView()
                .onAppear {
                    UserDefaults.standard.set(colorScheme == .dark ? true : false, forKey: "DarkMode")
                }
                .environment(\.colorScheme, darkMode ? .dark : .light)
        }
    }
}
