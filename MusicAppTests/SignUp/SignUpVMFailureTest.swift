//
//  SignUpVMFailureTest.swift
//  MusicAppTests
//
//  Created by Steve on 18/08/2023.
//

import XCTest
@testable import MusicApp

final class SignUpVMFailureTest: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var validationMock: SignupValidatorImp!
    private var vm: SignInSignUpVM!
    
    override func setUp() {
        networkingMock = NetworkingManagerSignUpFailureMock()
        validationMock = SignupValidatorSuccessMock()
        vm = SignInSignUpVM(networkingManager: networkingMock, validator: validationMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        validationMock = nil
        vm = nil
    }
    
    func test_with_unsuccessful_response_submission_state_is_unsuccessful() async throws {
        
        XCTAssertNil(vm.submissionState, "The view model state should be nil initially")
        defer { XCTAssertEqual(vm.submissionState, .unsuccessful, "The view model state should be unsuccessful") }
        
        await vm.signUp()
        XCTAssertTrue(vm.hasError, "The view model should have an error")
        XCTAssertNotNil(vm.error, "The view model error property shouldnt be nil")
        XCTAssertEqual(vm.error, .networking(error: NetworkingManager.NetworkingError.invalidUrl), "The error should be of type networking invalid url")
    }

}
