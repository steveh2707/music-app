//
//  NetworkingManagerTeacherSearchResponseFailureMock.swift
//  MusicAppTests
//
//  Created by Steve on 27/06/2023.
//

#if DEBUG
import Foundation

/// Mock Networking Manager to simulate failure for teacher search
class NetworkingManagerTeacherSearchResponseFailureMock: NetworkingManagerImpl {
    
    /// Function to mock a network request with a response to throw a specified error
    /// - Parameters:
    ///   - session: URL Session for request
    ///   - endpoint: Endpoint for request
    ///   - type: Model data type to be decoded
    /// - Returns: No return provided as error thrown
    func request<T>(session: URLSession, _ endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        throw NetworkingManager.NetworkingError.invalidUrl
    }
    
    /// Function to mock a network request without a response to throw a specified error
    /// - Parameters:
    ///   - session: URL Session for request
    ///   - endpoint: Endpoint for request
    func request(session: URLSession, _ endpoint: EndPoint) async throws {
    }
    
    
}
#endif
