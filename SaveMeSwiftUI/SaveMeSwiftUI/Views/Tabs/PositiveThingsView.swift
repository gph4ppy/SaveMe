//
//  PositiveThingsView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 05/03/2021.
//

import SwiftUI

struct PositiveThingsView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Things.time, ascending: false)], animation: .default)
    private var things: FetchedResults<Things>
    
    // Properties
    @ObservedObject var dateManager = DateManager()
    @State private var showingAlert = false
    @State private var alertText = ""
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    
    var body: some View {
        // Write Button
        let writeButton = {
            Button(action: { self.showingAlert = true }) {
                HStack {
                    Text(NSLocalizedString("add", comment: ""))
                    Image(systemName: "hand.thumbsup.fill")
                }
                .foregroundColor(Color(ColorManager.setColor(color)))
            }
        }()
        
        // Positive Things UI
        ScrollView(.vertical, showsIndicators: false) {
            // Date Picker
            DisclosureGroup(NSLocalizedString("select_date", comment: "")) {
                DatePicker(
                    "Date",
                    selection: $dateManager.date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
            }
            .padding()
            
            // Positive Things History for selected date
            // Check if positive things exist in selected date
            if things.filter { $0.date == dateManager.dateString }.isEmpty {
                // Didn't find positive things
                VStack {
                    Spacer()
                    Text("""
                        \(NSLocalizedString("no_data_things", comment: ""))
                        """)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(0.3)
                    .padding()
                }
            } else {
                // Found positive things
                List {
                    ForEach(things.filter { $0.date == dateManager.dateString }, id: \.self) { card in
                        VStack(alignment: .leading) {
                            Text("✅ \(card.content)")
                        }
                        .contextMenu {
                            // Copy button
                            Button(action: {
                                UIPasteboard.general.string = card.content
                            }) {
                                HStack {
                                    Text(NSLocalizedString("copy", comment: ""))
                                    Image(systemName: "doc.on.doc.fill")
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        deleteCard(offsets: indexSet)
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
            }
        }
        .alert(isPresented: $showingAlert,
               // TextField Alert
               TextAlert(title: NSLocalizedString("add_positive_thing", comment: ""), placeholder: "", accept: NSLocalizedString("save", comment: ""), cancel: NSLocalizedString("cancel", comment: ""), action: { (result) in
            
            if result == nil {
                self.showingAlert = false
            } else {
                alertText = result!
                saveThing()
            }
        }))
        .navigationBarItems(trailing: writeButton)
        .accentColor(Color(ColorManager.setColor(color)))
        .navigationBarTitle(NSLocalizedString("things_title", comment: ""))
    }
    
    /// This method saves positive things to the context.
    private func saveThing() {
        withAnimation {
            let newThing = Things(context: viewContext)
            newThing.content = alertText
            newThing.date = dateManager.dateString
            newThing.time = dateManager.timeString
            
            saveContext()
        }
    }
    
    /// This method removes positive thing from the context.
    private func deleteCard(offsets: IndexSet) {
        withAnimation {
            offsets.map { things[$0] }.forEach(viewContext.delete)
            saveContext()
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
