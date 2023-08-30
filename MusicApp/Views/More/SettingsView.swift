//
//  SettingsView.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import SwiftUI

/// View showing app settings
struct SettingsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @Binding var teacherDetailsUpdated: Int
    
    // MARK: BODY
    var body: some View {
        List {

            Section {
                if global.teacherDetails == nil {
                    NavigationLink {
                        let newTeacher = TeacherDetails(teacherID: 0, tagline: "", bio: "", locationTitle: "", locationLatitude: 0, locationLongitude: 0, averageReviewScore: 0, instrumentsTeachable: [])
                        EditTeacherDetails(teacherDetails: newTeacher, newTeacher: true, teacherDetailsUpdated: $teacherDetailsUpdated)
                    } label: {
                        Text("Become a Teacher")
                    }
                }
                NavigationLink {
                    MarkdownView(title: "Terms of Service", fileName: "TOS")
                } label: {
                    Text("Terms of Service")
                }
                NavigationLink {
                    MarkdownView(title: "Privacy Policy", fileName: "PP")
                } label: {
                    Text("Privacy Policy")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

