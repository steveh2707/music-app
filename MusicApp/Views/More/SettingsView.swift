//
//  SettingsView.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section {
               Text("Settings go here")
            }
            
            Section {
                NavigationLink {
//                    EditTeacherDetails(updatingExistingTeacher: false)
                } label: {
                    Text("Become a Teacher")
                }
                NavigationLink {
                    EmptyView()
                } label: {
                    Text("Terms of Service")
                }
                NavigationLink {
                    EmptyView()
                } label: {
                    Text("Privacy Policy")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
