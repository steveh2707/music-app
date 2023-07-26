//
//  BecomeTeacherVM.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import Foundation

class EditTeacherDetailsVM: ObservableObject {
    @Published var teacherDetails: TeacherDetails
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
    @Published var searchableText = ""
    @Published var selectedLocation: SelectedLocation?
    @Published var editable: Bool
    
    var teacherDetailsStart: TeacherDetails
    
    
    init(teacher: TeacherDetails, editable: Bool) {
        self.teacherDetailsStart = teacher
        self.teacherDetails = teacher
        self.editable = editable
    }
    
    
    @MainActor
    func updateTeacherDetails(token: String?) async {
        
        do {
            submissionState = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(teacherDetails)

            self.teacherDetails = try await NetworkingManager.shared.request(.updateTeacherDetails(token: token, submissionData: data), type: TeacherDetails.self)
            
            
            self.teacherDetailsStart = self.teacherDetails
            
            self.editable = false
            self.submissionState = .successful

        } catch {
            self.hasError = true
            self.submissionState = .unsuccessful
            
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
            default:
                self.error = .system(error: error)
            }
        }
    }
}
