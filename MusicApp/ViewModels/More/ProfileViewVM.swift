//
//  ProfileViewVM.swift
//  MusicApp
//
//  Created by Steve on 18/07/2023.
//

import Foundation

class ProfileViewVM: ObservableObject {
    
    @Published var userDetails: UserDetails
    @Published var teacherDetails: TeacherDetails?
    @Published var selectedLocation: SelectedLocation?
    
    var userDetailsStart: UserDetails
//    var teacherDetailsStart: TeacherDetails
    
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
   
    init(userDetails: UserDetails, teacherDetails: TeacherDetails? = nil) {
        self.userDetails = userDetails
        self.teacherDetails = teacherDetails
        self.userDetailsStart = userDetails
//        self.teacherDetailsStart = teacherDetails
//        self.selectedLocation = SelectedLocation(title: "", subtitle: "", latitude: teacherDetails.locationLatitude, longitude: teacherDetails.locationLongitude)
    }
    
//    @MainActor
//    func login() async {
//        
//        do {
//            submissionState = .submitting
//            
//            let encoder = JSONEncoder()
//            encoder.keyEncodingStrategy = .convertToSnakeCase
//            let data = try encoder.encode(credentials)
//
//            self.signInResponse = try await NetworkingManager.shared.request(.login(submissionData: data), type: SignInResponse.self)
//
//            submissionState = .successful
//        } catch {
//            self.hasError = true
//            self.submissionState = .unsuccessful
//            
//            switch error {
//            case is NetworkingManager.NetworkingError:
//                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
//            default:
//                self.error = .system(error: error)
//            }
//        }
//    }
    
    


}
