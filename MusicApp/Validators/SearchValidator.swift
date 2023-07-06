//
//  SearchValidator.swift
//  MusicApp
//
//  Created by Steve on 05/07/2023.
//

import Foundation

struct SearchValidator {
    
    func validate(_ searchCriteria: SearchCriteria) throws {
        
        if searchCriteria.instrumentId == nil {
            throw SearchValidatorError.invalidInstrumentId
        }
        
        if searchCriteria.gradeRankId == nil {
            throw SearchValidatorError.invalidGradeRankId
        }
        
    }
    
    enum SearchValidatorError: LocalizedError, Equatable {
        case invalidInstrumentId
        case invalidGradeRankId
        
        var errorDescription: String? {
            switch self {
            case .invalidInstrumentId:
                return "You must select an instrument"
            case .invalidGradeRankId:
                return "You must select a grade"
            }
        }
    }
}
