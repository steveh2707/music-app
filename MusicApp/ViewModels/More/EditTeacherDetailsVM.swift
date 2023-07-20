//
//  BecomeTeacherVM.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import Foundation

class EditTeacherDetailsVM: ObservableObject {
    @Published var teacherDetails: TeacherDetails
    
    @Published var searchableText = ""
    @Published var selectedLocation: SelectedLocation?
    
    var teacherDetailsStart: TeacherDetails
    
    
    init(teacher: TeacherDetails) {
        self.teacherDetailsStart = teacher
        self.teacherDetails = teacher
    }
}
