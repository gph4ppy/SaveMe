//
//  CarouselView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 12/03/2021.
//

import SwiftUI

struct CarouselView<Content: View>: View {
    private var numberOfViews: Int
    private var content: Content
    
    @State private var currentIndex: Int = 0
    
    private let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
    
    init(numberOfViews: Int, @ViewBuilder content: () -> Content) {
        self.numberOfViews = numberOfViews
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
            .animation(.spring())
            .onReceive(self.timer) { _ in
                self.currentIndex = (self.currentIndex + 1) % numberOfViews
            }
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        if value.startLocation.x > value.location.x {
                            // Swiped left
                            self.currentIndex = (self.currentIndex - 1) % numberOfViews
                        } else if value.startLocation.x < value.location.x {
                            // Swiped right
                            self.currentIndex = (self.currentIndex + 1) % numberOfViews
                        }
                    })
            )
        }
    }
}
