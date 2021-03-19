//
//  WriteDiary.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/03/2021.
//

import SwiftUI

struct WriteDiary: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    // Properties
    @ObservedObject var dateManager = DateManager()
    @ObservedObject static var userData = UserDataViewModel()
    @Binding var showingSheet: Bool
    @State var content = ""
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    @AppStorage("DarkMode") var darkMode: Bool = userData.isDarkMode
    
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
            
            // Diary Card content editor
            TextEditor(text: $content)
                .autocapitalization(.sentences)
                .disableAutocorrection(true)
        }
        .padding()
        .preferredColorScheme(darkMode ? .dark : .light)
    }
    
    /// This method diary card to the context.
    func saveDiaryCard() {
        withAnimation {
            let newCard = Diary(context: viewContext)
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
