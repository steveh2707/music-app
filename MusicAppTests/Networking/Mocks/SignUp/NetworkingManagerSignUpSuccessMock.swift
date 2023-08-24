//
//  NetworkingManagerSignUpSuccessMock.swift
//  MusicAppTests
//
//  Created by Steve on 18/08/2023.
//

#if DEBUG
import Foundation

class NetworkingManagerSignUpSuccessMock: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, _ endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "LoginResponseTestData", type: SignInResponse.self) as! T
    }
    
    func request(session: URLSession, _ endpoint: EndPoint) async throws {}
}
#endif
