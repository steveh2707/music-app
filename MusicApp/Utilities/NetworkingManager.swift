//
//  NetworkingManager.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation
import SwiftUI


/// Implementation of the NetworkingManager to allow mocks to be created and used for testing
protocol NetworkingManagerImpl {
    func request<T:Codable>(session: URLSession,
                            _ endpoint: EndPoint,
                            type: T.Type) async throws -> T
    
    func request(session: URLSession,
                 _ endpoint: EndPoint) async throws
}

/// Class to handle all API interaction
final class NetworkingManager: NetworkingManagerImpl {
    
    // shared instance of networking manager to be used throughout app
    static let shared = NetworkingManager()
    
    private init() {}
    
    /// Function to handle an API request, decode the response and return the decoded response
    /// - Parameters:
    ///   - session: URL session to be used. Default is shared. Allows URLSessions to be mocked.
    ///   - endpoint: URL endpoint
    ///   - type: Type of data provided by API response to be decoded
    /// - Returns: Decoded data
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
            
            guard let apiError = try? decoder.decode(ApiGenericResponse.self, from: data) else {
                throw NetworkingError.invalidStatusCode(statusCode: statusCode)
            }
            throw NetworkingError.apiError(message: apiError.message)
        }
        
        return try decoder.decode(T.self, from: data)
    }
    

    /// Function to handle an API request with no response
    /// - Parameters:
    ///   - session: URL session to be used. Default is shared. Allows URLSessions to be mocked.
    ///   - endpoint: URL endpoint
    func request(session: URLSession = .shared,
                _ endpoint: EndPoint) async throws {
        
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (data, response) = try await session.data(for: request)
        
        let decoder = JSONDecoder()
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            guard let apiError = try? decoder.decode(ApiGenericResponse.self, from: data) else {
                throw NetworkingError.invalidStatusCode(statusCode: statusCode)
            }
            throw NetworkingError.apiError(message: apiError.message)
        }
    }
    
    
    /// Enum of networking errors that can be returned to be displayed to user.
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
        
        /// Comparison function to allow NetworkingError conform to Equatable
        /// - Parameters:
        ///   - lhs: NetworkingError 1 to be compared
        ///   - rhs: NetworkingError 2 to be compared
        /// - Returns: Whether NetworkngErrors 1 & 2 are the same
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
    
    /// Function to build a complete HTTP request to be used for API request
    /// - Parameters:
    ///   - url: url build from Endpoint Enum
    ///   - methodType: API method type to be used for request
    /// - Returns: A complete URL request including HTTP method, any headers or body as required.
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
            
        case .PUT(let token, let data):
            request.httpMethod = "PUT"
            if let token { request.setValue(token, forHTTPHeaderField: "authorization") }
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = data
            
        case .POSTImg(let token, let data):
            request.httpMethod = "POST"
            if let token { request.setValue(token, forHTTPHeaderField: "authorization") }
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary="+boundary, forHTTPHeaderField:"Content-Type");
            if let data = data { request.httpBody = multipartFormDataBody(boundary, data) }
            
        case .DELETE(token: let token):
            request.httpMethod = "DELETE"
            if let token { request.setValue(token, forHTTPHeaderField: "authorization") }
        }
        
        print(String(format: "%@ %@", request.httpMethod ?? "", url.absoluteString))
        return request
    }
    
    
    /// Creates a multipart Form Data Body used for sending images to the API
    /// - Parameters:
    ///   - boundary: the multipart form data boundary
    ///   - imageData: the image to be sent to API
    /// - Returns: data coded to comply with multipart form data standard
    private func multipartFormDataBody(_ boundary: String, _ imageData: Data) -> Data {
        
        let lineBreak = "\r\n"
        let fromName = "test"
        
        var body = Data()
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"fromName\"\(lineBreak + lineBreak)")
        body.append("\(fromName + lineBreak)")
        
        
        if let uuid = UUID().uuidString.components(separatedBy: "-").first {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"imageUploads\"; fileName=\"\(uuid).jpg\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
            body.append(imageData)
            body.append(lineBreak)
        }
        
        body.append("--\(boundary)--\(lineBreak)") // End multipart form
        
        return body
    }
}


