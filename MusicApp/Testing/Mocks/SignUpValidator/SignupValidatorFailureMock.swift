//
//  SignupValidatorFailureMock.swift
//  MusicAppTests
//
//  Created by Steve on 18/08/2023.
//

#if DEBUG
import Foundation

/// Mock Validator to simulate failure for form validation
struct SignupValidatorFailureMock: SignupValidatorImp {
    
    /// Function to mock validation to throw a specified error
    /// - Parameter user: user details to be validated
    func validate(_ user: NewStudent) throws {
        throw SignupValidator.NewUserValidatorError.invalidFirstName
    }
    
}
#endif
