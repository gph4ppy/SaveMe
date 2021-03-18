//
//  SettingsView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 04/03/2021.
//

import SwiftUI

struct SettingsView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.avatar, ascending: false)])
    private var avatars: FetchedResults<User>
    
    // MARK: Properties
    @ObservedObject static var userData = UserDataViewModel()
    @AppStorage("Color") static var color: String = userData.accentColor
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    // Name
    @State var editName = false
    @State var newName = ""
    
    // Image
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var loadedImage = false
    @State var isImagePicker = false
    
    // Accent Colors
    let colors = ["Default",
                  "Blue",
                  "Red",
                  "Pink",
                  "Purple",
                  "Yellow"]
    @State var selectedColor = color
    
    // Notification
    @State var setupNotification = false
    @AppStorage("NotificationsEnabled") var isEnabled: Bool = false
    
    // About
    @State private var activeSheet: ActiveSheet?
    
    // Theme
    @AppStorage("DarkMode") var darkMode: Bool = userData.isDarkMode
    
    // MARK: - Settings
    var body: some View {
        let data = (avatars.first?.avatar ?? Data()) as Data
        let uiImage = UIImage(data: data)
        
        // Settings UI
        ZStack {
            VStack(spacing: 20) {
                // Change Image Button
                Button(action: {
                    DispatchQueue.main.async {
                        self.isImagePicker = true
                        self.activeSheet = .first
                    }
                }, label: {
                    if loadedImage && inputImage != nil {
                        // Show loaded image
                        VStack(spacing: 10) {
                            Image(uiImage: inputImage!)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 5)
                                        .shadow(color: Color.primary.opacity(0.7), radius: 7)
                                )
                            // Save image
                            Button(NSLocalizedString("save_profile_picture", comment: "")) {
                                DispatchQueue.main.async {
                                    viewContext.delete(avatars[0])
                                    saveImage()
                                    self.loadedImage = false
                                }
                            }
                            .foregroundColor(Color(ColorManager.setColor(SettingsView.color)))
                        }
                    } else {
                        // Otherwise show previous image
                        Image(uiImage: uiImage ?? UIImage(systemName: "person.circle")!.withTintColor(.systemGreen))
                            .resizable()
                            .accentColor(Color(ColorManager.setColor(SettingsView.color)))
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 5)
                                    .shadow(color: Color.primary.opacity(0.7), radius: 7)
                            )
                            .overlay(
                                HStack {
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        Circle()
                                            .fill(Color.primary)
                                            .frame(width: 35, height: 35)
                                            .overlay(
                                                ZStack {
                                                    Image(systemName: "paperclip")
                                                        .foregroundColor(.primary)
                                                        .colorInvert()
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: 3)
                                                        .shadow(color: Color.primary.opacity(0.7), radius: 7)
                                                }
                                            )
                                    }
                                }
                                .offset(x: -10, y: -5)
                            )
                    }
                })
                .padding(.top)
                
                // Change name on tap
                if !editName {
                    HStack {
                        Text(SettingsView.userData.name)
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            .foregroundColor(Color(ColorManager.setColor(SettingsView.color)))
                    }
                    .onTapGesture {
                        self.editName = true
                    }
                } else {
                    HStack {
                        Spacer()
                        // Name TextField
                        TextField("\(NSLocalizedString("current_name", comment: "")): \(SettingsView.userData.name)", text: $newName)
                            .lineLimit(1)
                        VStack {
                            // Save Button
                            Button(NSLocalizedString("save", comment: "")) {
                                UserDefaults.standard.setValue(newName, forKey: "Username")
                                SettingsView.userData.name = newName
                                self.editName = false
                            }
                            .foregroundColor(.green)
                            
                            // Cancel Button
                            Button(NSLocalizedString("cancel", comment: "")) {
                                self.editName = false
                            }
                            .foregroundColor(.red)
                        }
                        Spacer()
                    }
                }
                // Settings Form
                Form {
                    // App Settings
                    Section(header: Text(NSLocalizedString("app_settings_header", comment: ""))) {
                        // Accent Color
                        Picker(NSLocalizedString("select_accent_color", comment: ""), selection: $selectedColor) {
                            ForEach(colors, id: \.self) { color in
                                HStack {
                                    Color(ColorManager.setColor(color))
                                        .frame(width: 50)
                                        .clipShape(Circle())
                                    Text(setColorLabel(color))
                                }
                            }
                        }
                        
                        // Language
                        Button(NSLocalizedString("select_language", comment: "")) {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                        .foregroundColor(.primary)
                        
                        // Setup Notification
                        Toggle(NSLocalizedString("select_theme", comment: ""), isOn: $darkMode)
                        
                        // Setup Notification
                        Toggle(NSLocalizedString("setup_notifications", comment: ""), isOn: $isEnabled)
                    }
                    
                    // App Info
                    Section(header: Text(NSLocalizedString("app_info_header", comment: ""))) {
                        // App Version
                        HStack {
                            Text(NSLocalizedString("app_info_version", comment: ""))
                            Spacer() 
                            Text(appVersion ?? "⚠️")
                                .opacity(0.5)
                        }
                        
                        // Show About
                        Button(NSLocalizedString("about_title", comment: "")) {
                            self.isImagePicker = false
                            self.activeSheet = .second
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
        }
        .navigationBarTitle(NSLocalizedString("settings_title", comment: ""))
        .navigationBarHidden(false)
        .frame(width: UIScreen.main.bounds.width)
        .sheet(item: $activeSheet, onDismiss: {
            if isImagePicker {
                self.loadedImage = true
            }
        }) { item in
            switch item {
            case .first:
                ImagePicker(image: self.$inputImage)
            case .second:
                AboutView()
            }
        }
        .onChange(of: selectedColor, perform: { _ in
            UserDefaults.standard.setValue(ColorManager.setColor(selectedColor), forKey: "Color")
        })
        .onChange(of: darkMode, perform: { newValue in
            DispatchQueue.main.async {
                self.darkMode = newValue
                UserDefaults.standard.setValue(newValue, forKey: "DarkMode")
            }
        })
        .onChange(of: isEnabled, perform: { _ in
            if isEnabled {
                setupNotification = true
            } else {
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
            }
        })
        .blur(radius: setupNotification ? 30 : 0)
        .environment(\.colorScheme, darkMode ? .dark : .light)
        
        // Notification Alert
        if setupNotification {
            SetupNotification(showingAlert: $setupNotification, isEnabled: $isEnabled)
                .navigationBarHidden(true)
        }
    }
    
    /// This method loads an image to the placeholder
    func saveImage() {
        let data = getData()
        let userImage = User(context: viewContext)
        userImage.avatar = data
        
        saveContext()
    }
    
    /// This method gets the data from uploaded image
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
    
    /// This method sets the label in accent color selection view.
    /// - Parameter color: Name of the Color
    /// - Returns: Name of the Color in selected language
    func setColorLabel(_ color: String) -> String {
        switch color {
            case "Default": return NSLocalizedString("default", comment: "")
            case "Blue": return NSLocalizedString("blue", comment: "")
            case "Red": return NSLocalizedString("red", comment: "")
            case "Pink": return NSLocalizedString("pink", comment: "")
            case "Purple": return NSLocalizedString("purple", comment: "")
            case "Yellow": return NSLocalizedString("yellow", comment: "")
            default: return ""
        }
    }
}
