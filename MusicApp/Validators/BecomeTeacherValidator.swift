//
//  BecomeTeacherValidator.swift
//  MusicApp
//
//  Created by Steve on 23/08/2023.
//

import Foundation

/// Implementation of the BecomeTeacherValidator to allow mocks to be created and used for testing
protocol BecomeTeacherValidatorImp {
    func validate(_ teacher: TeacherDetails) throws
}

/// Struct to handle validating the become teacher form
struct BecomeTeacherValidator: BecomeTeacherValidatorImp {
    
    /// Validate inputs of form
    /// - Parameter teacher: teacher details to be validated
    func validate(_ teacher: TeacherDetails) throws {

        if teacher.tagline.isEmpty {
            throw BecomeTeacherValidatorError.invalidTagline
        }
        
        if teacher.bio.isEmpty {
            throw BecomeTeacherValidatorError.invalidBio
        }
        
        if teacher.locationTitle.isEmpty {
            throw BecomeTeacherValidatorError.invalidLocation
        }
        
        if teacher.instrumentsTeachable.isEmpty {
            throw BecomeTeacherValidatorError.invalidInstruments
        }
        
    }
    
    /// Custom errors that can be thrown by validator
    enum BecomeTeacherValidatorError: LocalizedError, Equatable {
        case invalidTagline
        case invalidBio
        case invalidLocation
        case invalidInstruments
        
        var errorDescription: String? {
            switch self {
            case .invalidTagline:
                return "Tagline cannot be empty"
            case .invalidBio:
                return "Bio cannot be empty"
            case .invalidLocation:
                return "Please select a location"
            case .invalidInstruments:
                return "Please add at least 1 instrument"
            }
        }
    }
    
}
