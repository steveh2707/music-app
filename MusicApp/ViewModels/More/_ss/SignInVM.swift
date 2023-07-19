//
//  LoginVM.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import Foundation



class SignInVM: ObservableObject {
    
    @Published var credentials = Credentials()
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    @Published var signInResponse: SignInResponse? = nil
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    
    @MainActor
    func login() async {
        
        do {
            submissionState = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(credentials)
            
            self.signInResponse = try await NetworkingManager.shared.request(.login(submissionData: data), type: SignInResponse.self)

            submissionState = .successful
        } catch {
            self.hasError = true
            self.submissionState = .unsuccessful
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}
