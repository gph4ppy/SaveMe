//
//  WritePositiveCard.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/03/2021.
//

import SwiftUI

struct WritePositiveCard: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    // Properties
    @ObservedObject var dateManager = DateManager()
    @ObservedObject var content = TextLimiterViewModel(limit: 100)
    @ObservedObject static var userData = UserDataViewModel()
    @Binding var showingSheet: Bool
    @State var showAlert = false
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    @AppStorage("DarkMode") var darkMode: Bool = userData.isDarkMode
    
    var body: some View {
        VStack {
            HStack {
                // "New Card" Title
                Text(NSLocalizedString("new_card", comment: ""))
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
            
            // Positive Card Content Editor
            TextEditor(text: $content.value)
                .autocapitalization(.sentences)
                .disableAutocorrection(true)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            // Card content can't be empty
            Alert(title: Text(NSLocalizedString("empty_card_title", comment: "")), message: Text(NSLocalizedString("empty_card_body", comment: "")), dismissButton: .default(Text(NSLocalizedString("empty_card_button", comment: ""))))
        }
        .preferredColorScheme(darkMode ? .dark : .light)
    }
    
    /// This method saves positive card to the context.
    func saveDiaryCard() {
        if content.value.isEmpty {
            // Show alert if content is empty
            self.showAlert = true
        } else {
            // Otherwise save card
            let newCard = Positive(context: viewContext)
            newCard.content = content.value
            
            saveContext()
            self.showingSheet = false
        }
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
