//
//  NewUserVM.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import Foundation

final class SignupVM: ObservableObject {
    
    @Published var newUser = NewStudent()
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
    
    private let validator = SignupValidator()
    

    @MainActor
    func signUp() async {
    
        do {
            try validator.validate(newUser)
            
            state = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(newUser)
            
            try await NetworkingManager.shared.request(.newUser(submissionData: data))
            
            state = .successful
            
        } catch {
            
            self.hasError = true
            self.state = .unsuccessful
            
            
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
