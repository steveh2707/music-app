//
//  NetworkingManagerUserResponseSuccessMock.swift
//  MusicAppTests
//
//  Created by Steve on 26/06/2023.
//

import Foundation
@testable import MusicApp

class NetworkingManagerTeacherResponseSuccessMock: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, _ endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "TeacherStaticTestData", type: TeacherDetails.self) as! T
    }
    
    func request(session: URLSession, _ endpoint: EndPoint) async throws {
    }
    
    
}
