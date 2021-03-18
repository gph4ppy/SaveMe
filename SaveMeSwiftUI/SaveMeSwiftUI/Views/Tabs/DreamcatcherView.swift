//
//  DreamcatcherView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 27/02/2021.
//

import SwiftUI

struct DreamcatcherView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Dream.date, ascending: false)], animation: .default)
    private var dreams: FetchedResults<Dream>
    
    // Properties
    @ObservedObject var dateManager = DateManager()
    @State var showingWritingPage = false
    @State var isDetail = false
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    
    var body: some View {
        var selectedDream = DreamModel(content: "", date: "", time: "")
        
        // Write Button
        let writeButton = {
            Button(action: {
                self.showingWritingPage = true
                self.isDetail = false
            }) {
                HStack {
                    Text(NSLocalizedString("write", comment: ""))
                    Image(systemName: "bed.double.fill")
                }
                .foregroundColor(Color(ColorManager.setColor(color)))
            }
        }()
        
        // Dreamcatcher UI
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
            
            // Dreams History for selected date
            // Check if dreams exist in selected date
            if dreams.filter { $0.date == dateManager.dateString }.isEmpty {
                // Didn't find dreams
                VStack {
                    Spacer()
                    Text("""
                        \(NSLocalizedString("no_data_dreams", comment: ""))
                        """)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(0.3)
                }
            } else {
                // Found dreams
                List {
                    ForEach(dreams.filter { $0.date == dateManager.dateString }, id: \.self) { card in
                        VStack(alignment: .leading) {
                            Button(action: {
                                self.showingWritingPage = true
                                self.isDetail = true
                                selectedDream = DreamModel(content: card.content, date: card.date, time: card.time)
                            }) {
                                HStack {
                                    Text(card.date)
                                    Spacer()
                                    Text(card.time)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                .font(.system(size: 15, weight: .bold))
                            }
                        }
                        .padding()
                        .contextMenu {
                            // Copy Date Button
                            Button(action: {
                                UIPasteboard.general.string = "\(card.date) \(card.time)"
                            }) {
                                HStack {
                                    Text(NSLocalizedString("copy_date", comment: ""))
                                    Image(systemName: "doc.on.doc.fill")
                                }
                            }
                            // Copy Card Contet Button
                            Button(action: {
                                UIPasteboard.general.string = card.content
                            }) {
                                HStack {
                                    Text(NSLocalizedString("copy_content", comment: ""))
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
        .navigationBarTitle(NSLocalizedString("dreamcatcher_title", comment: ""))
        .navigationBarItems(trailing: writeButton)
        .sheet(isPresented: $showingWritingPage) {
            WriteDream(showingSheet: self.$showingWritingPage, isDetailView: self.$isDetail, dream: selectedDream)
        }
    }
    
    // This method removes dream from the context.
    private func deleteCard(offsets: IndexSet) {
        withAnimation {
            offsets.map { dreams[$0] }.forEach(viewContext.delete)
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
