//
//  SignUpVMSuccessTests.swift
//  MusicAppTests
//
//  Created by Steve on 18/08/2023.
//

import XCTest
@testable import MusicApp

final class SignUpVMSuccessTests: XCTestCase {
    
    private var networkingMock: NetworkingManagerImpl!
    private var validationMock: SignupValidatorImp!
    private var vm: SignInSignUpVM!
    
    override func setUp() {
        networkingMock = NetworkingManagerSignUpSuccessMock()
        validationMock = SignupValidatorSuccessMock()
        vm = SignInSignUpVM(networkingManager: networkingMock, validator: validationMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        validationMock = nil
        vm = nil
    }
    
    func test_with_successful_response_submission_state_is_successful() async throws {
        
        XCTAssertNil(vm.submissionState, "The view model state should be nil initially")
        defer { XCTAssertEqual(vm.submissionState, .successful, "The view model state should be successful") }
        
        await vm.signUp()
    }
    
}
