//
//  SignupValidatorFailureMock.swift
//  MusicAppTests
//
//  Created by Steve on 18/08/2023.
//

#if DEBUG
import Foundation

struct SignupValidatorFailureMock: SignupValidatorImp {
    
    func validate(_ user: NewStudent) throws {
        throw SignupValidator.NewUserValidatorError.invalidFirstName
    }
    
}
#endif
