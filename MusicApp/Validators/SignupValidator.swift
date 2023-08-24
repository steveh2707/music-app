//
//  NewUserValidator.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import Foundation

protocol SignupValidatorImp {
    func validate(_ user: NewStudent) throws
}

struct SignupValidator: SignupValidatorImp {
    
    let ageLimit = 13
    
    func validate(_ user: NewStudent) throws {

        if user.firstName.isEmpty {
            throw NewUserValidatorError.invalidFirstName
        }
        
        if user.lastName.isEmpty {
            throw NewUserValidatorError.invalidLastName
        }
        
        if user.email.isEmpty {
            throw NewUserValidatorError.invalidEmail
        }
        
        if user.password.isEmpty {
            throw NewUserValidatorError.invalidPassword
        }
        
        if let userAge = Calendar.current.dateComponents([.year], from: user.inputDob, to: Date.now).year {
            if userAge < ageLimit {
                throw NewUserValidatorError.invalidDob(ageLimt: ageLimit)
            }
        }
    
        if !user.tos {
            throw NewUserValidatorError.invalidTos
        }
        
    }
    
    enum NewUserValidatorError: LocalizedError, Equatable {
        case invalidFirstName
        case invalidLastName
        case invalidEmail
        case invalidPassword
        case invalidDob(ageLimt: Int)
        case invalidTos
        
        var errorDescription: String? {
            switch self {
            case .invalidFirstName:
                return "First name cannot be empty"
            case .invalidLastName:
                return "Last name cannot be empty"
            case .invalidEmail:
                return "Email cannot be empty"
            case .invalidPassword:
                return "Password cannot be empty"
            case .invalidDob(let ageLimit):
                return "User must be older than \(ageLimit)"
            case .invalidTos:
                return "Please accept Terms of Service"
            }
        }
    }
    
}
