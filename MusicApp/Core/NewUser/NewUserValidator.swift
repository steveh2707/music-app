//
//  NewUserValidator.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import Foundation

struct NewUserValidator {
    
    func validate(_ user: NewUser) throws {
        
        if user.firstName.isEmpty {
            throw NewUserValidatorError.invalidFirstName
        }
        
        if user.lastName.isEmpty {
            throw NewUserValidatorError.invalidLastName
        }
        
        if user.email.isEmpty {
            throw NewUserValidatorError.invalidEmail
        }
        
    }
    
    enum NewUserValidatorError: LocalizedError {
        case invalidFirstName
        case invalidLastName
        case invalidEmail
        
        var errorDescription: String? {
            switch self {
            case .invalidFirstName:
                return "First name cannot be empty"
            case .invalidLastName:
                return "Last name cannot be empty"
            case .invalidEmail:
                return "Email cannot be empty"
            }
        }
    }
    
}
