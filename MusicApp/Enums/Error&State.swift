//
//  Networking.swift
//  MusicApp
//
//  Created by Steve on 28/06/2023.
//

import Foundation

enum SubmissionState {
    case submitting
    case successful
    case unsuccessful
}

enum ViewState {
    case fetching
    case finished
}


enum FormError: LocalizedError, Equatable {
    static func == (lhs: FormError, rhs: FormError) -> Bool {
        switch (lhs, rhs) {
        case (.networking(let lhsType), .networking(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.validation(let lhsType), .validation(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.system(let lhsType), .system(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
    
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
