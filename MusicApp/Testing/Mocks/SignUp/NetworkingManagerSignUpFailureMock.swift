//
//  NetworkingManagerSignUpFailureMock.swift
//  MusicApp
//
//  Created by Steve on 30/08/2023.
//

#if DEBUG
import Foundation

/// Mock Networking Manager to simulate failure on sign up
class NetworkingManagerSignUpFailureMock: NetworkingManagerImpl {
    
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
        throw NetworkingManager.NetworkingError.invalidUrl
    }
}
#endif
