//
//  SettingsView.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var global: Global
    
    @Binding var teacherDetailsUpdated: Int
    
    var body: some View {
        List {
            Section {
               Text("Settings go here")
            }
            
            Section {
                if global.teacherDetails == nil {
                    NavigationLink {
                        //                    EditTeacherDetails(updatingExistingTeacher: false)
                        let newTeacher = TeacherDetails(teacherID: 0, tagline: "", bio: "", locationTitle: "", locationLatitude: 0, locationLongitude: 0, averageReviewScore: 0, instrumentsTeachable: [])
                        EditTeacherDetails(teacherDetails: newTeacher, newTeacher: true, teacherDetailsUpdated: $teacherDetailsUpdated)
                    } label: {
                        Text("Become a Teacher")
                    }
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

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
