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
                TeacherView(teacherId: 1)
                    .tabItem {
                        Image(systemName: "figure.arms.open")
                        Text("Teacher")
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
