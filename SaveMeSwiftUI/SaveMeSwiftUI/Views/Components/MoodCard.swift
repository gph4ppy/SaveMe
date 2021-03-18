//
//  MoodCard.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 01/03/2021.
//

import SwiftUI

struct MoodCard: View {
    var mood: Mood
    
    var body: some View {
        Rectangle()
            .fill(Color.primary)
            .colorInvert()
            .overlay(
                HStack(alignment: .center) {
                    // Color stripe
                    setColor(emoji: mood.value)
                        .frame(width: 10)
                    
                    // Emoji
                    Image(uiImage: UIImage(data: mood.emoji) ?? UIImage(systemName: "questionmark.circle.fill")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 5)
                        .frame(width: 50, height: 50)
                    
                    Divider()
                    Spacer()
                    
                    // Date
                    Text(mood.date)
                    
                    Spacer()
                    Divider()
                    
                    Spacer()
                    
                    // Hour
                    Text(mood.time)
                    
                    Spacer()
                }
                .font(.footnote)
            )
            .frame(height: 60)
            .cornerRadius(12)
            .padding(5)
            .shadow(color: Color.primary.opacity(0.3), radius: 10)
    }
    
    /// This method sets the color of the stripe.
    /// - Parameter emoji: Emoji value (from slider)
    /// - Returns: Color for the stripe
    func setColor(emoji: Double) -> Color {
        switch emoji {
            case 0..<3: return .red
            case 3..<6: return .orange
            case 6...10: return .green
            default: return .gray
        }
    }
}
