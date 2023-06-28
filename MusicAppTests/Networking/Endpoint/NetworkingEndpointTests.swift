//
//  NetworkingEndpointTests.swift
//  MusicAppTests
//
//  Created by Steve on 26/06/2023.
//

import XCTest
@testable import MusicApp


final class NetworkingEndpointTests: XCTestCase {

    func test_with_configuration_endpoint_request_is_valid() {
        let endpoint = EndPoint.configuration
        
        XCTAssertEqual(endpoint.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/configuration", "Host should be /configuration")
        XCTAssertEqual(endpoint.methodType, .GET(), "The method type should be GET")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/configuration", "The generated url doesn't match our endpoint")
    }
    
    
    func test_with_teacher_endpoint_request_is_valid() {
        let teacherId = 1
        let endpoint = EndPoint.teacher(id: teacherId)
        
        XCTAssertEqual(endpoint.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/\(teacherId)", "Host should be /teacher/\(teacherId)")
        XCTAssertEqual(endpoint.methodType, .GET(), "The method type should be GET")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/\(teacherId)", "The generated url doesn't match our endpoint")
    }
    
    func test_with_search_endpoint_request_is_valid() {
        let page = 1
        let endpoint = EndPoint.search(submissionData: nil, page: page)
        
        XCTAssertEqual(endpoint.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/search", "Host should be /search")
        XCTAssertEqual(endpoint.methodType, .POST(data: nil), "The method type should be POST")
        XCTAssertEqual(endpoint.queryItems, ["page":"\(page)"])
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/search?page=\(page)", "The generated url doesn't match our endpoint")
    }
    

}



