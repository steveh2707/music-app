//
//  BecomeTeacherValidator.swift
//  MusicApp
//
//  Created by Steve on 23/08/2023.
//

import Foundation

protocol BecomeTeacherValidatorImp {
    func validate(_ teacher: TeacherDetails) throws
}

struct BecomeTeacherValidator: BecomeTeacherValidatorImp {
    
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
