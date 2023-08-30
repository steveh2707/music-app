//
//  BecomeTeacherVM.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import Foundation

/// View model for handling all business logic of EditTeacherDetails View
class EditTeacherDetailsVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var teacherDetails: TeacherDetails
    
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
    @Published var searchableText = ""
    @Published var selectedLocation: SelectedLocation
    @Published var editable: Bool
    
    var teacherDetailsStart: TeacherDetails
    var newTeacher: Bool
    
    private let networkingManager: NetworkingManagerImpl!
    private let validator: BecomeTeacherValidatorImp!
    
    
    // MARK: INITALIZATION
    init(teacher: TeacherDetails, newTeacher: Bool, networkingManager: NetworkingManagerImpl = NetworkingManager.shared,
         validator: BecomeTeacherValidatorImp = BecomeTeacherValidator()) {
        self.teacherDetailsStart = teacher
        self.teacherDetails = teacher
        self.selectedLocation = SelectedLocation(title: teacher.locationTitle, latitude: teacher.locationLatitude, longitude: teacher.locationLongitude)
        self.editable = newTeacher
        self.newTeacher = newTeacher
        self.networkingManager = networkingManager
        self.validator = validator
    }
    
    
    // MARK: FUNCTIONS

    @MainActor
    /// Function to interface with API to add a new teacher to database or update existing teachers details
    /// - Parameter token: JWT token provided to user at login for authentication
    func updateTeacherDetails(token: String?) async {
        
        do {
            try validator.validate(teacherDetails)
            
            submissionState = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(teacherDetails)

            if newTeacher {
                self.teacherDetails = try await NetworkingManager.shared.request(.newTeacher(token: token, submissionData: data), type: TeacherDetails.self)
                self.newTeacher = false
            } else {
                self.teacherDetails = try await NetworkingManager.shared.request(.updateTeacherDetails(token: token, submissionData: data), type: TeacherDetails.self)
            }
         
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
