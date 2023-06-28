//
//  Endpoint.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation

enum EndPoint {
    case configuration
    case teacher(id: Int)
    case newUser(submissionData: Data?)
    case login(submissionData: Data?)
    case search(submissionData: Data?, page: Int)
    case chat(id: Int, token: String?)
    case newMessage(chatId: Int, token: String, submissionData: Data?)
    case allChats(token: String?)

    // Use this for any items that need appended to request
    var methodType: MethodType {
        switch self {
        case .teacher,
                .configuration:
            return .GET()
            
        case .chat(_, let token):
            return .GET(token: token)
            
        case .newUser(let data),
                .login(let data),
                .search(let data, _):
            return .POST(data: data)
            
        case .newMessage(_, let token, let data):
            return .POST(token: token, data: data)
            
        case .allChats(let token):
            return .GET(token: token)
        }
    }
    
    var host: String { "localhost" }
    
    // Use this for any items that need included in the URL
    var path: String {
        switch self {
        case .configuration:
            return "/configuration"
        case .teacher(let id):
            return "/teacher/\(id)"
        case .newUser:
            return "/user"
        case .login:
            return "/user/login"
        case .search:
            return "/teacher/search"
        case .chat(let id, _):
            return "/chat/\(id)"
        case .newMessage(let chatId, _, _):
            return "/chat/message/\(chatId)"
        case .allChats:
            return "/chat"
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .search(_, let page):
            return ["page": "\(page)"]
        default:
            return nil
        }
    }


    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = host
        urlComponents.port = 4000
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        queryItems?.forEach{ item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        if requestQueryItems.count > 0 {
            urlComponents.queryItems = requestQueryItems
        }

        return urlComponents.url
    }
    
}

enum MethodType : Equatable {
    case GET(token: String? = nil)
    case POST(token: String? = nil, data: Data? = nil)
}
