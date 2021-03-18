//
//  HomeButton.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 26/02/2021.
//

import SwiftUI

struct HomeButton: View {
    let image: String
    let color: Color
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationLink(
            destination: getDestination(image)) {
            Circle()
                .fill(color)
                .frame(width: width / 3, height: width / 3)
                .overlay(
                    Image(systemName: image)
                        .foregroundColor(.white)
                        .font(.system(size: width / 6, weight: .semibold))
                )
        }
    }
    
    /// This method sets the destination based on Image Name
    /// - Parameter imageName: System Image Name (which defines which card should be opened)
    /// - Returns: AnyView Destination, which is used in NavLink
    func getDestination(_ imageName: String) -> AnyView {
        switch imageName {
            case "hand.thumbsup":
                return AnyView(MoodCheckerView())
            case "calendar":
                return AnyView(DiaryView())
            case "hands.sparkles.fill":
                return AnyView(PositiveThinkingView())
            case "bed.double.fill":
                return AnyView(DreamcatcherView())
            case "person.fill.questionmark":
                return AnyView(WhatHappenedView())
            case "face.dashed":
                return AnyView(PositiveThingsView())
            default:
                return AnyView(MoodCheckerView())
        }
    }
}
