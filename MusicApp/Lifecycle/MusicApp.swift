//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import SwiftUI

/// Set up app and tab views.
///
/// This struct sets up the app and defines what views are shown in the TabView based on whether the user is logged in or not.
@main
struct MusicApp: App {
    // MARK: PROPERTIES
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var global = Global()
    
    // MARK: BODY
    var body: some Scene {
        WindowGroup {
            TabView(selection: $global.selectedTab) {
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                    .task {
                        if global.isValidated { await global.fetchUnreadMessages() }
                    }
                
                if global.isValidated, global.userDetails != nil {
                    
                    // only show these tabs if user is logged in
                    AllChatsView()
                        .tabItem {
                            Image(systemName: "bubble.left.and.bubble.right")
                            Text("Chats")
                        }
                        .badge(global.unreadMessages)
                        .tag(2)
                        .task { await global.fetchUnreadMessages() }
                    
                    UserBookingsView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Bookings")
                        }
                        .tag(4)
                        .task { await global.fetchUnreadMessages() }
                    
                    ProfileView(userDetails: global.userDetails!, teacherDetails: global.teacherDetails)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")

                        }
                        .tag(3)
                        .task { await global.fetchUnreadMessages() }
                        
                } else {
                    
                    // show this view if the user is not logged in
                    SignInSignUpView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        .tag(3)
                }
            }
            .environmentObject(global)
            .task {
                if global.instruments.isEmpty {
                    await global.getConfiguration()
                }
            }
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        print("👷‍♂️ UI Test: \(UITestingHelper.isUITesting)")
        #endif
        return true
    }
}
