//
//  NetworkingManagerTests.swift
//  MusicAppTests
//
//  Created by Steve on 26/06/2023.
//

import XCTest
@testable import MusicApp

final class NetworkingManagerTests: XCTestCase {
    
    private var session: URLSession!
    private var url: URL!
    
    override func setUp() {
        url = URL(string: "http://localhost.4000/teacher/1")
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLSessionProtocol.self]
        session = URLSession(configuration: config)
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    
    func test_with_successful_response_response_is_valid() async throws {
        guard let path = Bundle.main.path(forResource: "TeacherStaticTestData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the static teacher file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, data)
        }
        
        let res = try await NetworkingManager.shared.request(session: session,
                                                       .teacher(id: 1),
                                                       type: Teacher.self)
        
        let staticJSON = try StaticJSONMapper.decode(file: "TeacherStaticTestData", type: Teacher.self)
        
        XCTAssertEqual(res, staticJSON, "The returned response type should be decoded properly")
    }
    
    
    func test_with_successful_response_void_is_valid() async throws {
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, nil)
        }
        
        _ = try await NetworkingManager.shared.request(session: session,
                                                       .teacher(id: 1))
    }
    
    
    func test_with_unsuccessful_response_code_in_invalid_range_is_invalid() async {
        let invalidStatusCode = 400
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: invalidStatusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, nil)
        }
        
        do {
            _ = try await NetworkingManager.shared.request(session: session,
                                                           .teacher(id: 1),
                                                           type: Teacher.self)
        } catch  {
        
            guard let networkingError = error as? NetworkingManager.NetworkingError else {
                XCTFail("Got the wroing type of error, expecting NetworkingManager NetworkingError")
                return
            }
            
            XCTAssertEqual(networkingError, NetworkingManager.NetworkingError.invalidStatusCode(statusCode: invalidStatusCode), "Error should be a networking error which throws an invalid status code")
        }
    }
    
    
    func test_with_unsuccessful_response_code_void_in_invalid_range_is_invalid() async {
        let invalidStatusCode = 400
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: invalidStatusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, nil)
        }
        
        do {
            _ = try await NetworkingManager.shared.request(session: session,
                                                           .teacher(id: 1))
        } catch  {
        
            guard let networkingError = error as? NetworkingManager.NetworkingError else {
                XCTFail("Got the wroing type of error, expecting NetworkingManager NetworkingError")
                return
            }
            
            XCTAssertEqual(networkingError, NetworkingManager.NetworkingError.invalidStatusCode(statusCode: invalidStatusCode), "Error should be a networking error which throws an invalid status code")
        }
    }
    
    
    func test_with_successful_response_with_invalid_json_is_invalid() async {
        guard let path = Bundle.main.path(forResource: "TeacherStaticTestData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the static teacher file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, data)
        }
        
        do {
            _ = try await NetworkingManager.shared.request(session: session,
                                                           .teacher(id: 1),
                                                           type: SearchResults.self)
        } catch {

            guard error is DecodingError else {
                XCTFail("Got the wroing type of error, expecting NetworkingManager NetworkingError")
                return
            }
            
        }
    }
}
