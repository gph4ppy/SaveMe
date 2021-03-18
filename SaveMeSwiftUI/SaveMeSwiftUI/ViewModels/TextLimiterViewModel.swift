//
//  TextLimiterViewModel.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/03/2021.
//

import SwiftUI

class TextLimiterViewModel: ObservableObject {
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    
    @Published var hasReachedLimit = false
}
