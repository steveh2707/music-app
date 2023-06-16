//
//  NetworkingManager.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation

//struct ApiError: Codable, Error {
//  let statusCode: Int
//  let name: String
//  let message: String
//}

final class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    
    func request<T:Codable>(_ endpoint: EndPoint,
                            type: T.Type) async throws -> T {
        
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkingError.failedToDecode
        }
        
        
//        let res = try decoder.decode(T.self, from: data)
//
//        return res
    }
    
    func request(_ endpoint: EndPoint) async throws {
        
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            switch statusCode {
            case 401:
                throw NetworkingError.invalidCredentials
            case 409:
                throw NetworkingError.emailExists
            default:
                throw NetworkingError.invalidStatusCode(statusCode: statusCode)
            }
            
        }
    }
    
    
    enum NetworkingError: LocalizedError {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode
        case invalidCredentials
        case emailExists
        
        var errorDescription: String? {
            switch self {
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
            case .invalidCredentials:
                return "Either your email or password are incorrect. Please try again"
            case .emailExists:
                return "Email already exists. Please login"
            }
        }
    }
    
    private func buildRequest(from url: URL, methodType: MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let data):
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = data
        }
        return request
    }
}





//extension NetworkingManager {
//
//    enum NetworkingError: LocalizedError {
//        case invalidUrl
//        case custom(error: Error)
//        case invalidStatusCode(statusCode: Int)
//        case invalidData
//        case failedToDecode(error: Error)
//    }
//}


//extension NetworkingManager.NetworkingError {
//    var errorDescription: String? {
//        switch self {
//        case .invalidUrl:
//            return "URL isn't valid"
//        case .invalidStatusCode:
//            return "Status code falls outside range"
//        case .invalidData:
//            return "Response data is invalid"
//        case .failedToDecode:
//            return "Failed to decode"
//        case .custom(let err):
//            return "Something went wrong. \(err.localizedDescription)"
//        }
//    }
//}


//private extension NetworkingManager {
//    func buildRequest(from url: URL, methodType: MethodType) -> URLRequest {
//        var request = URLRequest(url: url)
//
//        switch methodType {
//        case .GET:
//            request.httpMethod = "GET"
//        case .POST:
//            request.httpMethod = "POST"
//        }
//        return request
//    }
//}



