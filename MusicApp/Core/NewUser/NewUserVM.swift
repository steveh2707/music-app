//
//  NewUserVM.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import Foundation

final class NewUserVM: ObservableObject {
    
    @Published var newUser = NewUser()
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
    @Published var showError = false
    
    private let validator = NewUserValidator()
    

    @MainActor
    func create() async {
    
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
            case is NewUserValidator.NewUserValidatorError:
                self.error = .validation(error: error as! NewUserValidator.NewUserValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
        
    }
    
    enum SubmissionState {
        case unsuccessful
        case successful
        case submitting
    }
    
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
        
        var errorDescription: String? {
            switch self {
            case .networking(let err), .validation(let err):
                return err.errorDescription
            case .system(let err):
                return err.localizedDescription
            }
        }
    }
    
}
