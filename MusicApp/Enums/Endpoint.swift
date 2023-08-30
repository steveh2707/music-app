//
//  Endpoint.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation
import SwiftUI


/// Enum to handle building URL paths and assigning HTTP method types for all API endpoints to be used by the buildRequest function in NetworkingManager
enum EndPoint {

    // all of the API endpoints being accessed by the app, with required parameters
    case configuration
    case teacher(id: Int)
    case newUser(submissionData: Data?)
    case login(submissionData: Data?)
    case search(submissionData: Data?, page: Int)
    case favouriteTeachers(token: String?, page: Int)
    case updateUserDetails(token: String?, submissionData: Data?)
    case updateTeacherDetails(token: String?, submissionData: Data?)
    case newTeacher(token: String?, submissionData: Data?)
    case isTeacherFavourited(token: String?, id: Int)
    case favouriteTeacher(token: String?, id: Int)
    case unfavouriteTeacher(token: String?, id: Int)
    case teacherSchedule(token: String?)
    
    case chat(token: String?, id: Int)
    case chatFromTeacherId(token: String?, id: Int)
    case newMessage(token: String?, chatId: Int, submissionData: Data?)
    case allChats(token: String?)
    case allUnreadChats(token: String?)
    
    case teacherAvailability(token: String?, id: Int, startDate: Date, endDate: Date)
    case makeBooking(token: String?, submissionData: Data?)
    case allBookings(token: String?)
    case cancelBooking(token: String?, bookingId: Int, submissionData: Data?)
    case getTeachersReviews(id: Int)
    case getUsersReviews(token: String?)
    case newReview(token: String?, submissionData: Data?)
    case image(token: String?, submissionData: Data?)

    
    // defines the method type for each of the API endpoints from the MethodType enum
    var methodType: MethodType {
        switch self {
        case .teacher,
                .configuration,
                .getTeachersReviews:
            return .GET()
            
        case .chat(let token, _),
                .chatFromTeacherId(let token, _),
                .allChats(let token),
                .allUnreadChats(let token),
                .teacherAvailability(let token, _, _, _),
                .allBookings(let token),
                .getUsersReviews(let token),
                .favouriteTeachers(let token, _),
                .isTeacherFavourited(let token, _),
                .teacherSchedule(let token):
            return .GET(token: token)
            
        case .newUser(let data),
                .login(let data),
                .search(let data, _):
            return .POST(data: data)
            
        case .newMessage(let token, _, let data),
                .makeBooking(let token, let data),
                .newReview(let token, let data),
                .newTeacher(let token, let data):
            return .POST(token: token, data: data)
            
        case .cancelBooking(let token, _, let submissionData),
                .updateUserDetails(let token, let submissionData),
                .updateTeacherDetails(let token, let submissionData):
            return .PUT(token: token, data: submissionData)
            
        case .favouriteTeacher(let token, _):
            return .POST(token: token)

        case .image(let token, let submissionData):
            return .POSTImg(token: token, data: submissionData)
            
        case .unfavouriteTeacher(let token, _):
            return .DELETE(token: token)
        }
    }
    
    
    // defines the URL path and applies parameters as required
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
        case .chat(_, let id):
            return "/chat/conversation/\(id)"
        case .newMessage(_, let chatId, _):
            return "/chat/message/\(chatId)"
        case .allChats:
            return "/chat"
        case .allUnreadChats:
            return "/chat/unread"
        case .teacherAvailability(_, let id, _, _):
            return "/booking/availability/\(id)"
        case .makeBooking:
            return "/booking"
        case .allBookings:
            return "/booking"
        case .cancelBooking(_, let bookingId, _):
            return "/booking/\(bookingId)"
        case .image:
            return "/image"
        case .chatFromTeacherId:
            return "/chat/conversation"
        case .updateUserDetails:
            return "/user"
        case .updateTeacherDetails, .newTeacher:
            return "/teacher"
        case .newReview:
            return "/teacher/review"
        case .getTeachersReviews(let id):
            return "/teacher/\(id)/review"
        case .getUsersReviews:
            return "/user/review"
        case .favouriteTeachers:
            return "/teacher/favourite"
        case .isTeacherFavourited(_, let id),
                .favouriteTeacher(_, let id),
                .unfavouriteTeacher(_, let id):
            return "/teacher/\(id)/favourite"
        case .teacherSchedule:
            return "/teacher/availability"
        }
    }
    
    // adds query items to path as required
    var queryItems: [String: String]? {
        switch self {
        case .search(_, let page),
                .favouriteTeachers(_, let page):
            return ["page": "\(page)"]
        case .teacherAvailability(_, _, let startDate, let endDate):
            return ["start_date": "\(startDate)", "end_date": "\(endDate)"]
        case .chatFromTeacherId(_, let id):
            return ["teacher_id": "\(id)"]
        default:
            return nil
        }
    }

    // builds up all the components of the URL, adding the path and query items from above
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "localhost"
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

// all HTTP method types
enum MethodType : Equatable {
    case GET(token: String? = nil)
    case POST(token: String? = nil, data: Data? = nil)
    case PUT(token: String? = nil, data: Data? = nil)
    case POSTImg(token: String? = nil, data: Data? = nil)
    case DELETE(token: String? = nil)
}
