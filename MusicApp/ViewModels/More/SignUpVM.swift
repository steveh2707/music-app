//
//  NewUserVM.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import Foundation

final class SignUpVM: ObservableObject {
    
    @Published var newUser = NewStudent()
    @Published var signInResponse: SignInResponse? = nil
    
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
    
    private let validator = SignupValidator()
    

    @MainActor
    func signUp() async {
    
        do {
            try validator.validate(newUser)
            
            submissionState = .submitting
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(newUser)
            
            self.signInResponse = try await NetworkingManager.shared.request(.newUser(submissionData: data), type: SignInResponse.self)
            
            submissionState = .successful
            
        } catch {
            
            self.hasError = true
            self.submissionState = .unsuccessful
            
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
            case is SignupValidator.NewUserValidatorError:
                self.error = .validation(error: error as! SignupValidator.NewUserValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
        
    }
    

}
