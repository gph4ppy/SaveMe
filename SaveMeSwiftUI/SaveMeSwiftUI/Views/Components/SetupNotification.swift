//
//  SetupNotification.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 09/03/2021.
//

import SwiftUI

struct SetupNotification: View {
    @Binding var showingAlert: Bool
    @Binding var isEnabled: Bool
    @State private var date = Date()
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    
    var body: some View {
        VStack {
            ZStack {
                // Background Color
                Color.black
                    .opacity(0.8)
                    .overlay(
                        // Custom Alert Title
                        VStack {
                            Text(NSLocalizedString("setup_notifications_title", comment: ""))
                                .font(.title)
                            
                            Spacer().frame(height: 20)
                            
                            // Select Hour Picker
                            DatePicker(NSLocalizedString("select_hour", comment: ""), selection: $date, displayedComponents: .hourAndMinute)
                            
                            Spacer().frame(height: 10)
                            
                            // Request Permission Button
                            Button(action: requestPermission) {
                                Text(NSLocalizedString("allow_notifications", comment: ""))
                            }
                            .foregroundColor(Color(ColorManager.setColor(color)))
                            
                            Spacer().frame(height: 10)
                            
                            // Schedule Notification Button
                            Button(action: scheduleNotification) {
                                Text(NSLocalizedString("schedule_notifications", comment: ""))
                            }
                            .foregroundColor(Color(ColorManager.setColor(color)))
                            
                            Spacer()
                                .frame(height: 10)
                        }
                        .padding()
                        .foregroundColor(.white)
                    )
            }
            .frame(width: 300, height: 240, alignment: .center)
            .cornerRadius(20)
            .shadow(radius: 20)
            .overlay(
                // Close Custom Alert Button
                HStack {
                    Spacer()
                    VStack {
                        Circle()
                            .fill(Color.primary)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Button(action: {
                                    self.isEnabled = false
                                    UserDefaults.standard.setValue(isEnabled, forKey: "NotificationsEnabled")
                                    self.showingAlert = false
                                }) {
                                    ZStack {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.primary)
                                            .colorInvert()
                                        Circle()
                                            .stroke(Color.white, lineWidth: 3)
                                            .shadow(color: Color.primary.opacity(0.7), radius: 7)
                                    }
                                }
                            )
                        Spacer()
                    }
                }
                .offset(x: 10, y: -20)
            )
            .offset(y: -UIScreen.main.bounds.height / 4)
            Spacer()
        }
    }
    
    /// This method requests system permission for presenting notifications.
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, err) in
            if success {
                print("Completed.")
            } else if let error = err {
                print(error.localizedDescription)
            }
        }
    }
    
    /// This methods schedules notification for selected hour.
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        // Set content of notification for selected language
        content.title = NSLocalizedString("notification_title", comment: "")
        content.body = NSLocalizedString("notification_body", comment: "")
        content.sound = UNNotificationSound.default
        
        // Setup date and trigger
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        // Set notifications to "ON" and close the custom alert.
        self.isEnabled = true
        UserDefaults.standard.setValue(isEnabled, forKey: "NotificationsEnabled")
        self.showingAlert = false
    }
}
