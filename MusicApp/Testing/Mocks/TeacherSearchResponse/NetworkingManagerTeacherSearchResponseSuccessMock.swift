//
//  NetworkingManagerTeacherSearchResponseSuccessMock.swift
//  MusicAppTests
//
//  Created by Steve on 27/06/2023.
//

#if DEBUG
import Foundation

/// Mock Networking Manager to simulate success for teacher search
class NetworkingManagerTeacherSearchResponseSuccessMock: NetworkingManagerImpl {
    
    /// Function to mock a successful network request with a response, providing a JSON response from file
    /// - Parameters:
    ///   - session: URL Session for request
    ///   - endpoint: Endpoint for request
    ///   - type: Model data type to be decoded
    /// - Returns: Decoded JSON of type provided
    func request<T>(session: URLSession, _ endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "TeacherSearchStaticTestData", type: SearchResults.self) as! T
    }
    
    /// Function to mock a successful network request without a response
    /// - Parameters:
    ///   - session: URL Session for request
    ///   - endpoint: Endpoint for request
    func request(session: URLSession, _ endpoint: EndPoint) async throws {}
}
#endif
