//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import SwiftUI

@main
struct MusicApp: App {
    
    @StateObject var global = Global()

    
    var body: some Scene {
        WindowGroup {
            
            TabView(selection: $global.selectedTab) {
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                
                if global.isValidated {
                    AllChatsView()
                        .tabItem {
                            Image(systemName: "bubble.left.and.bubble.right")
                            Text("Chats")
                        }
                        .badge(global.unreadMessages)
                        .tag(2)
                }
                
                if global.isValidated {
                    UserBookingsView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Bookings")
                        }
                        .tag(4)
                }
                
                MoreView()
                    .tabItem {
                        Image(systemName: "ellipsis")
                        Text("More")
                        
                    }
                    .tag(3)
                

            }
            .environmentObject(global)
//            .task {
//                if global.isValidated {
//                    await global.fetchUnreadMessages()
//                }
//            }
            .onAppear {
#if DEBUG
                UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
#endif
            }
            
        }
        
        
        
    }
}
