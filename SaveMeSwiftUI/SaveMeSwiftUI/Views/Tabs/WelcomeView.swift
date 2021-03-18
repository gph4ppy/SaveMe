//
//  WelcomeView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 28/02/2021.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case first, second
    var id: Int {
        hashValue
    }
}

struct WelcomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var userData = UserDataViewModel()
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var loadedImage = false
    @State private var showingImagePicker = false
    @State var activeSheet: ActiveSheet?
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        VStack {
            // Title
            Text(NSLocalizedString("welcome_title", comment: ""))
                .font(.largeTitle)
            Text(NSLocalizedString("welcome_subheadline", comment: ""))
            
            Spacer()
                .frame(height: 15)
            
            VStack {
                Button(action: {
                    // Show Image Picker
                    DispatchQueue.main.async {
                        activeSheet = .first
                    }
                }, label: {
                    // If user uploaded image, show it
                    if loadedImage && inputImage != nil {
                        Image(uiImage: inputImage!)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.green, lineWidth: 3)
                            )
                    } else {
                        // Otherwise show blank image
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .foregroundColor(.green)
                    }
                })
                
                Spacer()
                    .frame(height: 30)
                
                // "What's your name" Label
                HStack {
                    Text(NSLocalizedString("question_name", comment: ""))
                        .font(.caption)
                        .opacity(0.7)
                    Spacer()
                }
                
                // Name TextField
                HStack {
                    TextField(NSLocalizedString("name_answer", comment: ""), text: $userData.name)
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Save data
                            let defaults = UserDefaults.standard
                            
                            defaults.setValue(true, forKey: "LoggedIn")
                            defaults.setValue(userData.name, forKey: "Username")
                            
                            saveImage()
                            
                            // Switch the views
                            activeSheet = .second
                        }) {
                            Text(NSLocalizedString("save", comment: ""))
                                .padding()
                                .frame(height: 30)
                                .foregroundColor(.primary)
                                .colorInvert()
                                .background(Color.green)
                                .clipShape(Capsule())
                        }
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
            .foregroundColor(Color.primary)
            Spacer()
            
            // Footer - legal informations
            Text("""
                \(NSLocalizedString("welcome_footer", comment: ""))
                """)
            .font(.system(size: 10))
            .opacity(0.7)
        }
        .padding()
        .fullScreenCover(item: $activeSheet, onDismiss: { self.loadedImage = true }) { item in
            switch item {
            case .first:
                ImagePicker(image: self.$inputImage)
            case .second:
                HomeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
    
    /// This method loads an image to the placeholder.
    func saveImage() {
        let data = getData()
        let userImage = User(context: viewContext)
        userImage.avatar = data
        
        saveContext()
    }
    
    /// This method gets the data from uploaded image.
    /// - Returns: image data, which will be saved in Core Data
    func getData() -> Data {
        if loadedImage {
            guard let image = self.inputImage,
                  let data = image.pngData() else {
                return Data()
            }
            return data
        } else {
            guard let image = UIImage(systemName: "person.circle")?.withTintColor(.systemGreen),
                  let data = image.pngData() else {
                return Data()
            }
            return data
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
