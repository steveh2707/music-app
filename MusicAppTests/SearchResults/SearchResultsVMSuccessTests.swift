//
//  SearchResultsVMSuccessTests.swift
//  MusicAppTests
//
//  Created by Steve on 27/06/2023.
//

import XCTest
@testable import MusicApp

final class SearchResultsVMSuccessTests: XCTestCase {
    
    private var networkingMock: NetworkingManagerImpl!
    private var vm: SearchResultsVM!
    
    override func setUp() {
        networkingMock = NetworkingManagerTeacherSearchResponseSuccessMock()
        let searchCriteria = SearchCriteria()
        vm = SearchResultsVM(networkingManager:  networkingMock, searchCriteria: searchCriteria)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func test_with_successful_response_teachers_array_is_set() async throws {
        XCTAssertEqual(vm.viewState, .none, "The view model shouldn't be loading any data")
        
        await vm.fetchTeachers()
        XCTAssertEqual(vm.teachers.count, 6, "There should be 6 users within the teachers array")
        XCTAssertEqual(vm.viewState, .finished, "The view model state should be finished")
    }
    
    
    func test_with_successful_paginated_response_teachers_array_is_set() async throws {
        XCTAssertEqual(vm.viewState, .none, "The view model shouldn't be loading any data")
        
        await vm.fetchTeachers()
        XCTAssertEqual(vm.teachers.count, 6, "There should be 6 users within the teachers array")
        
        await vm.fetchNextSetOfTeachers()
        XCTAssertEqual(vm.teachers.count, 12, "There should be 12 users within the teachers array")
        XCTAssertEqual(vm.page, 2, "The page should be 2")
        XCTAssertEqual(vm.viewState, .finished, "The view model state should be finished")
    }
    
    func test_with_reset_called_values_is_reset() async throws {

        await vm.fetchTeachers()
        XCTAssertEqual(vm.teachers.count, 6, "There should be 6 users within the teachers array")
        
        await vm.fetchNextSetOfTeachers()
        XCTAssertEqual(vm.teachers.count, 12, "There should be 12 users within the teachers array")
        XCTAssertEqual(vm.page, 2, "The page should be 2")
        
        await vm.fetchTeachers()
        XCTAssertEqual(vm.teachers.count, 6, "There should be 6 users within the teachers array")
        XCTAssertEqual(vm.page, 1, "The page should be 2")
        XCTAssertEqual(vm.totalPages, 5, "The page should be nil")
        XCTAssertEqual(vm.viewState, .finished, "The page should be nil")
    }
    
    func test_with_last_user_func_returns_true() async {
        await vm.fetchTeachers()
        let teacherData = try! StaticJSONMapper.decode(file: "TeacherSearchStaticTestData", type: SearchResults.self)
        let shouldLoadData = vm.shouldLoadData(id: teacherData.results.last!.id)
        
        XCTAssertTrue(shouldLoadData, "The last id should match")
    }
}
