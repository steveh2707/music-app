//
//  NetworkingManagerTeacherSearchResponseFailureMock.swift
//  MusicAppTests
//
//  Created by Steve on 27/06/2023.
//

import Foundation
@testable import MusicApp

class NetworkingManagerTeacherSearchResponseFailureMock: NetworkingManagerImpl {
    func request<T>(session: URLSession, _ endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        throw NetworkingManager.NetworkingError.invalidUrl
    }
    
    func request(session: URLSession, _ endpoint: EndPoint) async throws {
    }
    
    
}
