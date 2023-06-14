//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import SwiftUI

@main
struct MusicApp: App {
    var body: some Scene {
        WindowGroup {
            
            TabView {
                TeacherView(teacherId: 1)
                    .tabItem {
                        Image(systemName: "figure.arms.open")
                        Text("Teacher")
                    }
                
                NewUserView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Me")
                    }
            }
            
            
        }
    }
}
