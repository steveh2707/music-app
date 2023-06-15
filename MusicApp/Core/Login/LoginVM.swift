//
//  LoginVM.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import Foundation

struct Credentials: Codable {
    var email: String = ""
    var password: String = ""
}

class LoginVM: ObservableObject {
    
    @Published var credentials = Credentials()
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    
    @MainActor
    func login() async {
        
        do {
            state = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(credentials)
            
            try await NetworkingManager.shared.request(.login(submissionData: data))
            
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
