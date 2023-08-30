//
//  NetworkingManagerSignUpFailureMock.swift
//  MusicApp
//
//  Created by Steve on 30/08/2023.
//

#if DEBUG
import Foundation

class NetworkingManagerSignUpFailureMock: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, _ endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        throw NetworkingManager.NetworkingError.invalidUrl
    }
    
    func request(session: URLSession, _ endpoint: EndPoint) async throws {
        throw NetworkingManager.NetworkingError.invalidUrl
    }
}
#endif
