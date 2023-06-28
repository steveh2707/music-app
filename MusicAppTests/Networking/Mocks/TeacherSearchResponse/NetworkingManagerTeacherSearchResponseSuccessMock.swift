//
//  NetworkingManagerTeacherSearchResponseSuccessMock.swift
//  MusicAppTests
//
//  Created by Steve on 27/06/2023.
//

import Foundation
@testable import MusicApp

class NetworkingManagerTeacherSearchResponseSuccessMock: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, _ endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "TeacherSearchStaticTestData", type: SearchResults.self) as! T
    }
    
    func request(session: URLSession, _ endpoint: EndPoint) async throws {
    }
    
    
}
