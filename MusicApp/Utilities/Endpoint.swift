//
//  Endpoint.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation

enum EndPoint {
    case teacher(id: Int)
    case newUser(submissionData: Data?)
    case login(submissionData: Data?)
    case search(submissionData: Data?)

    var methodType: MethodType {
        switch self {
        case .teacher:
            return .GET
        case .newUser(let data), .login(let data), .search(let data):
            return .POST(data: data)
        }
    }
    
    var path: String {
        switch self {
        case .teacher(let id):
            return "/teacher/\(id)"
        case .newUser:
            return "/new_user"
        case .login:
            return "/login"
        case .search:
            return "/search"
        }
    }
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "localhost"
        urlComponents.port = 4000
        urlComponents.path = path
        
        return urlComponents.url
    }
    
}

enum MethodType {
    case GET
    case POST(data: Data?)
}
