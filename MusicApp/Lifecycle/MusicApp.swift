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
                
                if global.isValidated {
                    AllChatsView()
                        .tabItem {
                            Image(systemName: "bubble.left.and.bubble.right")
                            Text("Chats")
                        }
                        .badge(global.unreadMessages)
                        .tag(2)
                }
                
                MoreView()
                    .tabItem {
                        Image(systemName: "ellipsis")
                        Text("More")
                        
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
