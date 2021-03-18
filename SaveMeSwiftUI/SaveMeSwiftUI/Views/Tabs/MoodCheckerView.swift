//
//  MoodCheckerView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 27/02/2021.
//

import SwiftUI

struct MoodCheckerView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Mood.time, ascending: false)], animation: .default)
    private var moods: FetchedResults<Mood>
    
    // Properties
    @ObservedObject var dateManager = DateManager()
    @State var value = 5.0
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    let size = UIScreen.main.bounds
    
    var body: some View {
        // Save Button
        let saveButton = {
            Button(action: saveMood) {
                HStack {
                    Text(NSLocalizedString("save", comment: ""))
                    Image(systemName: "square.and.arrow.down")
                }
                .foregroundColor(Color(ColorManager.setColor(color)))
            }
        }()
        
        // Mood Tracker UI
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                // Emoji
                setEmoji(value: value)
                    .resizable()
                    .frame(width: size.width / 4, height: size.width / 4)
                    .shadow(color: .orange, radius: 5)
                
                // Slider
                CustomSlider(value: $value)
                    .padding(.vertical)
                
                // Date Picker
                DisclosureGroup(NSLocalizedString("select_date", comment: "")) {
                    DatePicker(
                        "Date",
                        selection: $dateManager.date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                // Mood History for selected date
                DisclosureGroup(NSLocalizedString("browse_history", comment: "")) {
                    VStack(spacing: 5) {
                        Text(NSLocalizedString("select_date_info", comment: ""))
                            .font(.caption)
                            .opacity(0.8)
                        
                        // Check if moods exist in selected date
                        if moods.filter { $0.date == dateManager.dateString }.isEmpty {
                            // Didn't find moods
                            VStack {
                                Spacer()
                                Text("""
                                \(NSLocalizedString("no_data_moods", comment: ""))
                                """)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .opacity(0.3)
                            }
                        } else {
                            // Found moods
                            List {
                                ForEach(moods.filter { $0.date == dateManager.dateString }, id: \.self) { mood in
                                    MoodCard(mood: mood)
                                }
                                .onDelete { indexSet in
                                    deleteMood(offsets: indexSet)
                                }
                            }
                            .frame(height: size.height / 1.5)
                        }
                    }
                    
                }
            }
            .padding(.horizontal)
            .accentColor(Color(ColorManager.setColor(color)))
        }
        .navigationBarTitle(NSLocalizedString("mood_title", comment: ""))
        .navigationBarItems(trailing: saveButton)
    }
    
    /// Thiis method sets emoji img for slider value.
    /// - Parameter value: Slider value
    /// - Returns: Emoji Image
    func setEmoji(value: Double) -> Image {
        switch value {
            case 0..<1: return Image("Cry")
            case 1..<2: return Image("Sad")
            case 2..<3: return Image("Mad")
            case 3..<4: return Image("Angry")
            case 4..<5: return Image("Neutral")
            case 5..<6: return Image("Chilled")
            case 6..<7: return Image("Smiling")
            case 7..<8: return Image("Happy")
            case 8..<9: return Image("Glad")
            case 9...10: return Image("Lovely")
            default: return Image(systemName: "questionmark.circle.fill")
        }
    }
    
    /// This method saves mood to the context.
    private func saveMood() {
        let data = getData()
        
        withAnimation {
            let newMood = Mood(context: viewContext)
            newMood.emoji = data
            newMood.value = self.value
            newMood.date = dateManager.dateString
            newMood.time = dateManager.timeString
            
            saveContext()
        }
    }
    
    // This method removes mood from the context.
    private func deleteMood(offsets: IndexSet) {
        withAnimation {
            offsets.map { moods[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    /// This method gets the data from uploaded image.
    /// - Returns: image data, which will be saved in Core Data
    func getData() -> Data {
        let image: Image = setEmoji(value: value)
        let uiImage: UIImage = image.asUIImage()
        
        guard let data = uiImage.pngData() else {
            return Data()
        }
        
        return data
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
