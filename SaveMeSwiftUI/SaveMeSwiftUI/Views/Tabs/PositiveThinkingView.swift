//
//  PositiveThinkingView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 27/02/2021.
//

import SwiftUI

struct PositiveThinkingView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Positive.content, ascending: false)], animation: .default)
    private var positiveCards: FetchedResults<Positive>
    
    // Properties
    let size = UIScreen.main.bounds.width / 2 - 20
    @State var showingWritingPage = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    
    var body: some View {
        // Add card button
        let addButton = {
            Button(action: { showingWritingPage = true }) {
                HStack {
                    Text(NSLocalizedString("add", comment: ""))
                    Image(systemName: "plus")
                }
                .foregroundColor(Color(ColorManager.setColor(color)))
            }
        }()
        
        // Positive Thinking Cards
        ScrollView(.vertical, showsIndicators: false) {
            if positiveCards.isEmpty {
                // Didn't find cards
                VStack {
                    Spacer()
                    Text("""
                        \(NSLocalizedString("no_data_thinking", comment: ""))
                        """)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(0.3)
                    .padding()
                }
            } else {
                // Found cards
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                    ForEach(positiveCards.indices, id: \.self) { index in
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                            .cornerRadius(12)
                            .frame(width: size, height: size)
                            .shadow(color: Color.primary.opacity(0.3), radius: 10)
                            .overlay(
                                LazyVStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(positiveCards[index].content)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            )
                            .contextMenu {
                                // Copy Button
                                Button(action: {
                                    UIPasteboard.general.string = positiveCards[index].content
                                }) {
                                    HStack {
                                        Text(NSLocalizedString("copy", comment: ""))
                                        Image(systemName: "doc.on.doc.fill")
                                    }
                                }
                                // Delete Button
                                Button(action: {
                                    deleteCard(index: index)
                                }) {
                                    HStack {
                                        Text(NSLocalizedString("delete", comment: ""))
                                        Image(systemName: "trash.fill")
                                    }
                                }
                            }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle(NSLocalizedString("thinking_title", comment: ""))
        .navigationBarItems(trailing: addButton)
        .sheet(isPresented: $showingWritingPage) {
            WritePositiveCard(showingSheet: self.$showingWritingPage)
        }
    }
    
    // This method removes positive thinking card from the context.
    private func deleteCard(index: Int) {
        viewContext.delete(positiveCards[index])
        saveContext()
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
