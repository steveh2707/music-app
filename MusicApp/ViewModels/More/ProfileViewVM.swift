//
//  ProfileViewVM.swift
//  MusicApp
//
//  Created by Steve on 18/07/2023.
//

import Foundation

/// View model for handling all business logic of Profile View
class ProfileViewVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var userDetails: UserDetails
    @Published var teacherDetails: TeacherDetails?
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
    @Published var editable = false
    
    var userDetailsStart: UserDetails

    // MARK: INITALIZATION
    init(userDetails: UserDetails, teacherDetails: TeacherDetails? = nil) {
        self.userDetails = userDetails
        self.teacherDetails = teacherDetails
        self.userDetailsStart = userDetails
    }
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to interface with API to update existing user details
    /// - Parameter token: JWT token provided to user at login for authentication
    func updateUserDetails(token: String?) async {
        
        do {
            submissionState = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(userDetails)

            self.userDetails = try await NetworkingManager.shared.request(.updateUserDetails(token: token, submissionData: data), type: UserDetails.self)
            self.userDetailsStart = self.userDetails
            
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
