//
//  AboutView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 11/03/2021.
//

import SwiftUI

struct AboutView: View {
    // Properties
    let year = Calendar.current.component(.year, from: Date())
    @AppStorage("DarkMode") var darkMode: Bool = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack {
                // "About" Title
                Text(NSLocalizedString("about_title", comment: ""))
                    .font(.largeTitle)
                    .padding(.top)
                Divider()
                
                Spacer()
                    .frame(height: 20)
                
                HStack {
                    // Author Profile Image
                    Image("Author")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    // Author info
                    VStack(alignment: .leading) {
                        Text("Jakub Dąbrowski")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("\(year - 2002)\(NSLocalizedString("author_info", comment: ""))")
                            .font(.caption)
                    }
                }
                
                Spacer()
                    .frame(height: 20)
                
                // App description
                Text("""
                    \(NSLocalizedString("about_body", comment: ""))
                    """)
                    .font(.system(size: 13))
            }
        })
        .preferredColorScheme(darkMode ? .dark : .light)
        .padding()
    }
}
