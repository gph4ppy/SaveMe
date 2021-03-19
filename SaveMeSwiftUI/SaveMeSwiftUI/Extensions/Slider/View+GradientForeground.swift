//
//  View+GradientForeground.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 19/03/2021.
//

import SwiftUI

extension View {
    /// This method creates gradient and masks it with the View, which creates gradient foreground
    /// - Parameter colors: An array of Colors
    /// - Returns: View
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
}
