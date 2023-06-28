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
    @Published var error: NetworkingManager.NetworkingError?
    @Published var loginResponse: LoginResponse? = nil
    
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
            
            self.loginResponse = try await NetworkingManager.shared.request(.login(submissionData: data), type: LoginResponse.self)

            state = .successful
        } catch {
            self.hasError = true
            self.state = .unsuccessful
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}
