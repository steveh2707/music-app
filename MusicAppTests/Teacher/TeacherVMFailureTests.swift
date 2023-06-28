//
//  TeacherVMFailureTests.swift
//  MusicAppTests
//
//  Created by Steve on 27/06/2023.
//

import XCTest
@testable import MusicApp

final class TeacherVMFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var vm: TeacherVM!
    
    override func setUp() {
        networkingMock = NetworkingManagerTeacherResponseFailureMock()
        vm = TeacherVM(networkingManager:  networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func test_with_unsuccessful_response_error_is_handled() async {
        XCTAssertEqual(vm.state, .none, "The view model shouldn't be loading any data")
        
        await vm.getTeacherDetails(teacherId: 1)
        XCTAssertTrue(vm.hasError, "The view model should have an error")
        XCTAssertNotNil(vm.error, "The view model error should be set")
        XCTAssertEqual(vm.state, .unsuccessful, "The view model state should be finished")
    }

}
