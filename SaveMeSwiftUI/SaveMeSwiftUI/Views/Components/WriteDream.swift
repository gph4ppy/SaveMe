//
//  WriteDream.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 04/03/2021.
//

import SwiftUI

struct WriteDream: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    // Properties
    @ObservedObject var dateManager = DateManager()
    @ObservedObject static var userData = UserDataViewModel()
    @Binding var showingSheet: Bool
    @Binding var isDetailView: Bool
    @State var content = ""
    @State var dream: DreamModel
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    @AppStorage("DarkMode") var darkMode: Bool = userData.isDarkMode
    
    var body: some View {
        VStack {
            HStack {
                // Date
                Text(isDetailView ? dream.date : dateManager.dateString)
                    .font(.system(size: 25, weight: .bold))
                
                Spacer()
                
                // If Writing View, show save button
                // Otherwise [Detail View] hide it
                if !isDetailView {
                    Button(action: saveDream) {
                        HStack {
                            Text(NSLocalizedString("save", comment: ""))
                            Image(systemName: "square.and.pencil")
                        }
                        .foregroundColor(Color(ColorManager.setColor(color)))
                    }
                }
            }
            
            Divider()
            
            if isDetailView {
                // If detail view, show scrollable dream content
                ScrollView(.vertical, showsIndicators: false) {
                    Text(dream.content)
                }
            } else {
                // Otherwise show editor
                TextEditor(text: $content)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
            }
        }
        .padding()
        .preferredColorScheme(darkMode ? .dark : .light)
    }
    
    /// This method saves dream to the context.
    func saveDream() {
        withAnimation {
            let newDream = Dream(context: viewContext)
            newDream.content = content
            newDream.date = dateManager.dateString
            newDream.time = dateManager.timeString
            
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
