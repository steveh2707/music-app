//
//  NewUserValidatorSuccessMock.swift
//  MusicAppTests
//
//  Created by Steve on 18/08/2023.
//

#if DEBUG
import Foundation

/// Mock Validator to simulate success for form validation
struct SignupValidatorSuccessMock: SignupValidatorImp {
    
    /// Function to mock a successful validation
    /// - Parameter user: user details to be validated
    func validate(_ user: NewStudent) throws {}
    
}
#endif
