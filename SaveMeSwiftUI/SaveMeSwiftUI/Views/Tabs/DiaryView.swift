//
//  DiaryView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 27/02/2021.
//

import SwiftUI

struct DiaryView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Diary.time, ascending: false)], animation: .default)
    private var diaryCards: FetchedResults<Diary>
    
    // Properties
    @ObservedObject var dateManager = DateManager()
    @State var showingWritingPage = false
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    
    var body: some View {
        // Write Button
        let writeButton = {
            Button(action: { self.showingWritingPage = true }) {
                HStack {
                    Text(NSLocalizedString("write", comment: ""))
                    Image(systemName: "calendar.badge.plus")
                }
                .foregroundColor(Color(ColorManager.setColor(color)))
            }
        }()
        
        // Diary UI
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
            
            // Diary Cards History for selected date
            // Check if diary cards exist in selected date
            if diaryCards.filter { $0.date == dateManager.dateString }.isEmpty {
                // Didn't find diary cards
                VStack {
                    Spacer()
                    Text("""
                        \(NSLocalizedString("no_data_diary", comment: ""))
                        """)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(0.3)
                }
            } else {
                // Found diary cards
                List {
                    ForEach(diaryCards.filter { $0.date == dateManager.dateString }, id: \.self) { card in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(card.date)
                                Spacer()
                                Text(card.time)
                            }
                            .font(.system(size: 15, weight: .bold))
                            
                            Divider()
                            Text(card.content)
                        }
                        .padding()
                        .contextMenu {
                            // Copy Button
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
        .accentColor(Color(ColorManager.setColor(color)))
        .navigationBarTitle(NSLocalizedString("diary_title", comment: ""))
        .navigationBarItems(trailing: writeButton)
        .sheet(isPresented: $showingWritingPage) {
            WriteDiary(showingSheet: self.$showingWritingPage)
        }
    }
    
    // This method removes diary card from the context.
    private func deleteCard(offsets: IndexSet) {
        withAnimation {
            offsets.map { diaryCards[$0] }.forEach(viewContext.delete)
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
