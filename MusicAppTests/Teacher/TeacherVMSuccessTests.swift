//
//  TeacherVMSuccessTests.swift
//  MusicAppTests
//
//  Created by Steve on 26/06/2023.
//

import XCTest
@testable import MusicApp

final class TeacherVMSuccessTests: XCTestCase {
    
    private var networkingMock: NetworkingManagerImpl!
    private var vm: TeacherVM!
    
    override func setUp() {
        networkingMock = NetworkingManagerTeacherResponseSuccessMock()
        vm = TeacherVM(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func test_with_successful_response_teacher_details_is_set() async throws {
        
        XCTAssertEqual(vm.viewState, .none, "The view model shouldn't be loading any data")
        
        await vm.getTeacherDetails(teacherId: 1)
        XCTAssertNotNil(vm.teacher, "The teacher details should not be nil")
        XCTAssertEqual(vm.teacher?.userID, 1, "The userId should be 1")

        let teacherDetailsData = try StaticJSONMapper.decode(file: "TeacherStaticTestData", type: Teacher.self)
        XCTAssertEqual(vm.teacher, teacherDetailsData, "The response from our networking mock should match")
        
        XCTAssertEqual(vm.viewState, .finished, "The view state should be successful")
    }
    

}
