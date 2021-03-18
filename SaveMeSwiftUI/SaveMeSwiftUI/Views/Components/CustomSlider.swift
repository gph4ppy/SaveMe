//
//  CustomSlider.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 28/02/2021.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray)
                Rectangle()
                    .gradientForeground(colors: setGradient(value: value))
                    .frame(width: geometry.size.width * CGFloat(self.value / 10), height: 15)
            }
            .cornerRadius(12)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ (value) in
                        self.value = min(max(0, Double(value.location.x / geometry.size.width * 10)), 10)
                    })
            )
        }
    }
    
    /// This method sets the gradient for the slider.
    /// - Parameter value: Slider value
    /// - Returns: Color array
    func setGradient(value: Double) -> [Color] {
        switch value {
            case 0..<4: return [.red]
            case 4..<6: return [.red, .orange]
            case 6...10: return [.red, .orange, .green]
            default: return [.gray]
        }
    }
}
