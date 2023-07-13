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
