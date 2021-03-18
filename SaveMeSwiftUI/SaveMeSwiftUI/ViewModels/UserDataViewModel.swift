//
//  UserDataViewModel.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 28/02/2021.
//

import Foundation

class UserDataViewModel: ObservableObject {
    static let defaults = UserDefaults.standard
    
    @Published var name = defaults.string(forKey: "Username") ?? ""
    @Published var accentColor = defaults.string(forKey: "Color") ?? NSLocalizedString("default", comment: "")
    @Published var isLogged = defaults.bool(forKey: "LoggedIn")
    @Published var firstTime = defaults.optionalBool(forKey: "FirstTime") ?? true
    @Published var isDarkMode = defaults.bool(forKey: "DarkMode")
}
