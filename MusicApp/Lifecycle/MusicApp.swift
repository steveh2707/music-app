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
    @State var selectedTab = 1
    
    var body: some Scene {
        WindowGroup {
            
            TabView(selection: $selectedTab) {
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                
                AllChatsView()
                    .tabItem {
                        Image(systemName: "bubble.left.and.bubble.right")
                        Text("Chats")
                    }
                    .tag(2)
                
                ProfileLoginSwitcher()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                        
                    }
                    .tag(3)
            }
            .environmentObject(global)
            
            .onAppear {
#if DEBUG
                UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
#endif
            }
            
        }
        
        
        
    }
}
