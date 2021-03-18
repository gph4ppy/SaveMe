//
//  ColorManager.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 10/03/2021.
//

import SwiftUI

class ColorManager {
    /// This method sets the color for NSLocalizedStrings
    /// - Parameter color: NSLocalizedString color
    /// - Returns: Name of the color from Assets
    public static func setColor(_ color: String) -> String {
        switch color {
        case "Default", "Domyślny": return "Default"
        case "Blue", "Niebieski": return "Blue"
        case "Red", "Czerwony": return "Red"
        case "Pink", "Różowy": return "Pink"
        case "Purple", "Fioletowy": return "Purple"
        case "Yellow", "Żółty": return "Yellow"
        default: return ""
        }
    }
}
