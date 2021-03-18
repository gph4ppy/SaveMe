//
//  WriteFeelings.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 06/03/2021.
//

import SwiftUI

enum Feeling {
    case positive
    case negative
}

struct WriteFeelings: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    // Properties
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    @AppStorage("DarkMode") var darkMode: Bool = userData.isDarkMode
    @ObservedObject var dateManager = DateManager()
    @ObservedObject static var userData = UserDataViewModel()
    @Binding var showingSheet: Bool
    @State private var selectedFeeling: Feeling = .positive
    @State private var showingAlert = true
    @State private var content = ""
    private let positiveContent = NSLocalizedString("positive_feelings", comment: "")
    private let negativeContent = NSLocalizedString("negative_feelings", comment: "")
    
    var body: some View {
        VStack {
            HStack {
                // Date
                Text(dateManager.dateString)
                    .font(.system(size: 25, weight: .bold))
                
                Spacer()
                
                // Save Button
                Button(action: saveDiaryCard) {
                    HStack {
                        Text(NSLocalizedString("save", comment: ""))
                        Image(systemName: "square.and.pencil")
                    }
                    .foregroundColor(Color(ColorManager.setColor(color)))
                }
            }
            Divider()
            
            // Content Editor
            TextEditor(text: $content)
                .autocapitalization(.words)
                .disableAutocorrection(true)
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            // Alert - Positive or Negative feelings?
            Alert(
                title: Text(NSLocalizedString("feelings_alert_title", comment: "")),
                message: Text(NSLocalizedString("feelings_alert_body", comment: "")),
                primaryButton: .default(Text(NSLocalizedString("positive", comment: ""))) {
                    selectedFeeling = .positive
                    content = positiveContent
                },
                secondaryButton: .default(Text(NSLocalizedString("negative", comment: ""))) {
                    selectedFeeling = .negative
                    content = negativeContent
                }
            )
        }
        .preferredColorScheme(darkMode ? .dark : .light)
    }
    
    /// This method saves diary card to the context.
    func saveDiaryCard() {
        withAnimation {
            let newCard = Feelings(context: viewContext)
            newCard.content = content
            newCard.date = dateManager.dateString
            newCard.time = dateManager.timeString
            
            saveContext()
        }
        
        self.showingSheet = false
    }
    
    /// This method saves the context.
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
