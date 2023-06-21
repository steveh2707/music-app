//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import SwiftUI

@main
struct MusicApp: App {
    
    @StateObject var authentication = Authentication()
    @State var selectedTab = 1
    
    var body: some Scene {
        WindowGroup {
            
            TabView(selection: $selectedTab) {
                
                //                SearchResultsView()
                //                    .tabItem {
                //                        Image(systemName: "magnifyingglass")
                //                        Text("Search")
                //                    }
                //                    .tag(1)
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                
                ProfileLoginSwitcher()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                        
                    }
                    .environmentObject(authentication)
                    .tag(2)
                
                
            }
            
            .onAppear {
#if DEBUG
                UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
#endif
            }
            
        }
        
        
        
    }
}
