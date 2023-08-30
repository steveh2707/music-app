//
//  NewUserValidatorSuccessMock.swift
//  MusicAppTests
//
//  Created by Steve on 18/08/2023.
//

#if DEBUG
import Foundation

struct SignupValidatorSuccessMock: SignupValidatorImp {
    
    func validate(_ user: NewStudent) throws {}
    
}
#endif
