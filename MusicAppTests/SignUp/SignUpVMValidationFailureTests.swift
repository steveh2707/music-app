//
//  SignUpVMValidationFailureTests.swift
//  MusicAppTests
//
//  Created by Steve on 18/08/2023.
//

import XCTest
@testable import MusicApp

final class SignUpVMValidationFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var validationMock: SignupValidatorImp!
    private var vm: SignInSignUpVM!
    
    override func setUp() {
        networkingMock = NetworkingManagerSignUpSuccessMock()
        validationMock = SignupValidatorFailureMock()
        vm = SignInSignUpVM(networkingManager: networkingMock, validator: validationMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        validationMock = nil
        vm = nil
    }
    
    func test_with_invalid_form_submission_state_is_invalid() async {
        
        XCTAssertNil(vm.submissionState, "The view model state should be nil initially")
        defer { XCTAssertEqual(vm.submissionState, .unsuccessful, "The submission state should be unsuccessful") }
        
        await vm.signUp()
        XCTAssertTrue(vm.hasError, "The view model should have an error")
        XCTAssertNotNil(vm.error, "The view model error property shouldnt be nil")
        XCTAssertEqual(vm.error, .validation(error: SignupValidator.NewUserValidatorError.invalidFirstName), "The error should be of type invalid first name")
    }

}
