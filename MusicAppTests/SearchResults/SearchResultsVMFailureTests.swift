//
//  SearchResultsVMFailureTests.swift
//  MusicAppTests
//
//  Created by Steve on 27/06/2023.
//

import XCTest
@testable import MusicApp

final class SearchResultsVMFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var vm: SearchResultsVM!
    
    override func setUp() {
        networkingMock = NetworkingManagerTeacherSearchResponseFailureMock()
        let searchCriteria = SearchCriteria()
        vm = SearchResultsVM(networkingManager:  networkingMock, searchCriteria: searchCriteria)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func test_with_unsuccessful_response_error_is_handled() async {
        XCTAssertEqual(vm.viewState, .none, "The view model shouldn't be loading any data")
        
        await vm.fetchTeachers()
        XCTAssertTrue(vm.hasError, "The view model should have an error")
        XCTAssertNotNil(vm.error, "The view model error should be set")
        XCTAssertEqual(vm.viewState, .finished, "The view model state should be finished")
    }

}
