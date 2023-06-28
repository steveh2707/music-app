//
//  NetworkingManager.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation


protocol NetworkingManagerImpl {
    func request<T:Codable>(session: URLSession,
                            _ endpoint: EndPoint,
                            type: T.Type) async throws -> T
    
    func request(session: URLSession,
                 _ endpoint: EndPoint) async throws
}

final class NetworkingManager: NetworkingManagerImpl {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    // request with response
    func request<T:Codable>(session: URLSession = .shared,
                            _ endpoint: EndPoint,
                            type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (data, response) = try await session.data(for: request)
        
        let decoder = JSONDecoder()
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            guard let apiError = try? decoder.decode(ApiError.self, from: data) else {
                throw NetworkingError.invalidStatusCode(statusCode: statusCode)
            }
            throw NetworkingError.apiError(message: apiError.message)
        }
        
        guard let decodedResponse = try? decoder.decode(T.self, from: data) else {
            throw NetworkingError.failedToDecode
        }
        return decodedResponse
    }
    
    
    // request with no response
    func request(session: URLSession = .shared, _ endpoint: EndPoint) async throws {
        
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (data, response) = try await session.data(for: request)
        
        let decoder = JSONDecoder()
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            guard let apiError = try? decoder.decode(ApiError.self, from: data) else {
                throw NetworkingError.invalidStatusCode(statusCode: statusCode)
            }
            throw NetworkingError.apiError(message: apiError.message)
        }
    }
    
    
    enum NetworkingError: LocalizedError, Equatable {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode
        case apiError(message: String)
        
        var errorDescription: String? {
            switch self {
            case .apiError(let err):
                return err
            case .invalidUrl:
                return "URL isn't valid"
            case .invalidStatusCode:
                return "Status code falls outside range"
            case .invalidData:
                return "Response data is invalid"
            case .failedToDecode:
                return "Failed to decode."
            case .custom(let err):
                return "Something went wrong. \(err.localizedDescription)"
                
            }
        }
        
        // implemented to make NetworkingError conform to Equatable
        static func == (lhs: NetworkingManager.NetworkingError, rhs: NetworkingManager.NetworkingError) -> Bool {
            
            switch(lhs, rhs) {
            case (.apiError(let lhsType), .apiError(let rhsType)):
                return lhsType == rhsType
            case (.invalidUrl, .invalidUrl):
                return true
            case(.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
                return lhsType == rhsType
            case(.invalidData, .invalidData):
                return true
            case (.failedToDecode, .failedToDecode):
                return true
            case(.custom(let lhsType), .custom(error: let rhsType)):
                return lhsType.localizedDescription == rhsType.localizedDescription
            default:
                return false
            }
        }
    }
    
    private func buildRequest(from url: URL, methodType: MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET(let token):
            request.httpMethod = "GET"
            if let token { request.setValue(token, forHTTPHeaderField: "authorization") }
            
        case .POST(let token, let data):
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = data
            if let token { request.setValue(token, forHTTPHeaderField: "authorization") }
        }
        return request
    }
}

