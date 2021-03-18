//
//  HomeView.swift
//  SaveMeSwiftUI
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 26/02/2021.
//

import SwiftUI

struct HomeView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.avatar, ascending: false)])
    private var avatars: FetchedResults<User>
    
    // Properties
    @State var top = UIApplication.shared.windows.first?.safeAreaInsets.top
    @AppStorage("Username") var name: String = UserDataViewModel().name
    @AppStorage("Color") var color: String = UserDataViewModel().accentColor
    @AppStorage("FirstTime") var firstTime: Bool = UserDataViewModel().firstTime
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        let data = (avatars.first?.avatar ?? Data()) as Data
        let uiImage = UIImage(data: data)
        
        NavigationView {
            ZStack {
                VStack {
                    // Custom NavBar
                    Rectangle()
                        .colorInvert()
                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                        .ignoresSafeArea()
                        .frame(width: width, height: height / 10)
                        .shadow(color: Color.primary.opacity(0.2), radius: 15)
                        .overlay(
                            HStack {
                                // Greeting
                                Text("\(NSLocalizedString("hello", comment: ""))\(name.isEmpty ? "!" : ", \(name)!")")
                                    .font(.system(size: 30, weight: .semibold))
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                // User Image -> Settings View
                                NavigationLink(destination: SettingsView()) {
                                    Image(uiImage: uiImage ?? UIImage(systemName: "person.circle")!.withTintColor(.systemGreen))
                                        .resizable()
                                        .accentColor(Color(ColorManager.setColor(color)))
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            .padding(.top, top)
                        )
                    
                    // Menu Buttons
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 50) {
                            HomeButton(image: "hand.thumbsup", color: .green)
                            HomeButton(image: "calendar", color: .pink)
                            HomeButton(image: "hands.sparkles.fill", color: .orange)
                            HomeButton(image: "bed.double.fill", color: .purple)
                            HomeButton(image: "person.fill.questionmark", color: .blue)
                            HomeButton(image: "face.dashed", color: .red)
                        }
                        .padding()
                    }
                }
                .blur(radius: firstTime ? 30 : 0)
                .navigationBarHidden(true)
                
                // Welcome CarouselView [Tutorial]
                if firstTime {
                    GeometryReader { geometry in
                        CarouselView(numberOfViews: 3) {
                            VStack(spacing: 20) {
                                Text(NSLocalizedString("welcome_title", comment: ""))
                                    .font(.largeTitle)
                                    .padding(.top)
                                
                                Text("""
                                                \(NSLocalizedString("tutorial_swipe", comment: ""))
                                                """)
                                
                                Image("Home")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .shadow(color: Color.primary.opacity(0.3), radius: 10)
                                    .padding(.bottom)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            
                            VStack(spacing: 20) {
                                Text(NSLocalizedString("tutorial_delete_title", comment: ""))
                                    .font(.largeTitle)
                                    .padding(.top)
                                
                                Text("""
                                                \(NSLocalizedString("tutorial_delete_body", comment: ""))
                                                """)
                                
                                Image("Delete")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .shadow(color: Color.primary.opacity(0.3), radius: 10)
                                    .padding(.bottom)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            
                            VStack(spacing: 20) {
                                Text(NSLocalizedString("tutorial_hold_title", comment: ""))
                                    .font(.largeTitle)
                                    .padding(.top)
                                
                                Text("""
                                                \(NSLocalizedString("tutorial_hold_body", comment: ""))
                                                """)

                                Image("Hold")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .shadow(color: Color.primary.opacity(0.3), radius: 10)
                                    .padding(.bottom)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                    .frame(height: height / 1.5, alignment: .center)
                    // Close tutorial Button
                    .overlay(
                        HStack {
                            Spacer()
                            VStack {
                                Circle()
                                    .fill(Color.primary)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Button(action: {
                                            self.firstTime = false
                                            UserDefaults.standard.setValue(firstTime, forKey: "FirstTime")
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
                    .background(Color(.systemBackground))
                    .padding()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color(ColorManager.setColor(color)))
    }
}
