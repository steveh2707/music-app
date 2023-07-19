//
//  BecomeTeacherVM.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import Foundation

class EditTeacherDetailsVM: ObservableObject {
    @Published var teacher: TeacherDetails
    
    @Published var searchableText = ""
    @Published var selectedLocation: SelectedLocation?
    
    
    init(teacher: TeacherDetails) {
        self.teacher = teacher
    }
}
