//
//  NetworkingEndpointTests.swift
//  MusicAppTests
//
//  Created by Steve on 26/06/2023.
//

import XCTest
@testable import MusicApp


final class NetworkingEndpointTests: XCTestCase {

    func test_with_configuration_endpoint_request_is_valid() {
        let endpoint = EndPoint.configuration
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/configuration", "Host should be /configuration")
        XCTAssertEqual(endpoint.methodType, .GET(), "The method type should be GET")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/configuration", "The generated url doesn't match our endpoint")
    }
    
    
    func test_with_teacher_endpoint_request_is_valid() {
        let teacherId = 1
        let endpoint = EndPoint.teacher(id: teacherId)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/\(teacherId)", "Host should be /teacher/\(teacherId)")
        XCTAssertEqual(endpoint.methodType, .GET(), "The method type should be GET")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/\(teacherId)", "The generated url doesn't match our endpoint")
    }
    
    func test_with_search_endpoint_request_is_valid() {
        let page = 1
        let endpoint = EndPoint.search(submissionData: nil, page: page)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/search", "Host should be /search")
        XCTAssertEqual(endpoint.methodType, .POST(data: nil), "The method type should be POST")
        XCTAssertEqual(endpoint.queryItems, ["page":"\(page)"])
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/search?page=\(page)", "The generated url doesn't match our endpoint")
    }
    
    func test_newUser_endpoint_request_is_valid() {
        let submissionData: Data? = nil
        let endpoint = EndPoint.newUser(submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/user", "Path should be /user")
        XCTAssertEqual(endpoint.methodType, .POST(data: submissionData), "The method type should be POST")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/user", "The generated URL doesn't match our endpoint")
    }
    
    func test_login_endpoint_request_is_valid() {
        let submissionData: Data? = nil
        let endpoint = EndPoint.login(submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/user/login", "Path should be /user/login")
        XCTAssertEqual(endpoint.methodType, .POST(data: submissionData), "The method type should be POST")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/user/login", "The generated URL doesn't match our endpoint")
    }
    
    

    func test_favouriteTeachers_endpoint_request_is_valid() {
        let page = 1
        let token = "test-token"
        let endpoint = EndPoint.favouriteTeachers(token: token, page: page)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/favourite", "Path should be /teacher/favourite")
        XCTAssertEqual(endpoint.methodType, .GET(token: token), "The method type should be GET with token")
        XCTAssertEqual(endpoint.queryItems, ["page":"\(page)"])
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/favourite?page=\(page)", "The generated URL doesn't match our endpoint")
    }
    
    
    //MARK: From here

    func test_updateUserDetails_endpoint_request_is_valid() {
        let token = "test-token"
        let submissionData: Data? = nil
        let endpoint = EndPoint.updateUserDetails(token: token, submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/user", "Path should be /user")
        XCTAssertEqual(endpoint.methodType, .PUT(token: token, data: submissionData), "The method type should be PUT with token and data")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/user", "The generated URL doesn't match our endpoint")
    }

    func test_updateTeacherDetails_endpoint_request_is_valid() {
        let token = "test-token"
        let submissionData: Data? = nil
        let endpoint = EndPoint.updateTeacherDetails(token: token, submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher", "Path should be /teacher")
        XCTAssertEqual(endpoint.methodType, .PUT(token: token, data: submissionData), "The method type should be PUT with token and data")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher", "The generated URL doesn't match our endpoint")
    }

    func test_newTeacher_endpoint_request_is_valid() {
        let token = "test-token"
        let submissionData: Data? = nil
        let endpoint = EndPoint.newTeacher(token: token, submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher", "Path should be /teacher")
        XCTAssertEqual(endpoint.methodType, .POST(token: token, data: submissionData), "The method type should be POST with token and data")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher", "The generated URL doesn't match our endpoint")
    }

    func test_isTeacherFavourited_endpoint_request_is_valid() {
        let token = "test-token"
        let teacherId = 1
        let endpoint = EndPoint.isTeacherFavourited(token: token, id: teacherId)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/\(teacherId)/favourite", "Path should be /teacher/\(teacherId)/favourite")
        XCTAssertEqual(endpoint.methodType, .GET(token: token), "The method type should be GET with token")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/\(teacherId)/favourite", "The generated URL doesn't match our endpoint")
    }

    func test_favouriteTeacher_endpoint_request_is_valid() {
        let token = "test-token"
        let teacherId = 1
        let endpoint = EndPoint.favouriteTeacher(token: token, id: teacherId)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/\(teacherId)/favourite", "Path should be /teacher/\(teacherId)/favourite")
        XCTAssertEqual(endpoint.methodType, .POST(token: token), "The method type should be POST with token")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/\(teacherId)/favourite", "The generated URL doesn't match our endpoint")
    }
    
    func test_unfavouriteTeacher_endpoint_request_is_valid() {
        let token = "test-token"
        let teacherId = 1
        let endpoint = EndPoint.unfavouriteTeacher(token: token, id: teacherId)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/\(teacherId)/favourite", "Path should be /teacher/\(teacherId)/favourite")
        XCTAssertEqual(endpoint.methodType, .DELETE(token: token), "The method type should be DELETE with token")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/\(teacherId)/favourite", "The generated URL doesn't match our endpoint")
    }

    func test_chat_endpoint_request_is_valid() {
        let token = "test-token"
        let chatId = 1
        let endpoint = EndPoint.chat(token: token, id: chatId)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/chat/conversation/\(chatId)", "Path should be /chat/conversation/\(chatId)")
        XCTAssertEqual(endpoint.methodType, .GET(token: token), "The method type should be GET with token")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/chat/conversation/\(chatId)", "The generated URL doesn't match our endpoint")
    }

    func test_chatFromTeacherId_endpoint_request_is_valid() {
        let token = "test-token"
        let teacherId = 1
        let endpoint = EndPoint.chatFromTeacherId(token: token, id: teacherId)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/chat/conversation", "Path should be /chat/conversation")
        XCTAssertEqual(endpoint.methodType, .GET(token: token), "The method type should be GET with token")
        XCTAssertEqual(endpoint.queryItems, ["teacher_id":"\(teacherId)"])
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/chat/conversation?teacher_id=\(teacherId)", "The generated URL doesn't match our endpoint")
    }
    
    func test_newMessage_endpoint_request_is_valid() {
        let token = "test-token"
        let chatId = 1
        let submissionData: Data? = nil
        let endpoint = EndPoint.newMessage(token: token, chatId: chatId, submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/chat/message/\(chatId)", "Path should be /chat/message/\(chatId)")
        XCTAssertEqual(endpoint.methodType, .POST(token: token, data: submissionData), "The method type should be POST with token and data")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/chat/message/\(chatId)", "The generated URL doesn't match our endpoint")
    }

    func test_allChats_endpoint_request_is_valid() {
        let token = "test-token"
        let endpoint = EndPoint.allChats(token: token)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/chat", "Path should be /chat")
        XCTAssertEqual(endpoint.methodType, .GET(token: token), "The method type should be GET with token")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/chat", "The generated URL doesn't match our endpoint")
    }

    func test_allUnreadChats_endpoint_request_is_valid() {
        let token = "test-token"
        let endpoint = EndPoint.allUnreadChats(token: token)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/chat/unread", "Path should be /chat/unread")
        XCTAssertEqual(endpoint.methodType, .GET(token: token), "The method type should be GET with token")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/chat/unread", "The generated URL doesn't match our endpoint")
    }

    func test_makeBooking_endpoint_request_is_valid() {
        let token = "test-token"
        let submissionData: Data? = nil
        let endpoint = EndPoint.makeBooking(token: token, submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/booking", "Path should be /booking")
        XCTAssertEqual(endpoint.methodType, .POST(token: token, data: submissionData), "The method type should be POST with token and data")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/booking", "The generated URL doesn't match our endpoint")
    }
    
    func test_allBookings_endpoint_request_is_valid() {
        let token = "test-token"
        let endpoint = EndPoint.allBookings(token: token)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/booking", "Path should be /booking")
        XCTAssertEqual(endpoint.methodType, .GET(token: token), "The method type should be GET with token")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/booking", "The generated URL doesn't match our endpoint")
    }

    func test_cancelBooking_endpoint_request_is_valid() {
        let token = "test-token"
        let bookingId = 1
        let submissionData: Data? = nil
        let endpoint = EndPoint.cancelBooking(token: token, bookingId: bookingId, submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/booking/\(bookingId)", "Path should be /booking/\(bookingId)")
        XCTAssertEqual(endpoint.methodType, .PUT(token: token, data: submissionData), "The method type should be PUT with token and data")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/booking/\(bookingId)", "The generated URL doesn't match our endpoint")
    }
    
    func test_getTeachersReviews_endpoint_request_is_valid() {
        let teacherId = 1
        let endpoint = EndPoint.getTeachersReviews(id: teacherId)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/\(teacherId)/review", "Path should be /teacher/\(teacherId)/review")
        XCTAssertEqual(endpoint.methodType, .GET(), "The method type should be GET")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/\(teacherId)/review", "The generated URL doesn't match our endpoint")
    }

    func test_getUsersReviews_endpoint_request_is_valid() {
        let token = "test-token"
        let endpoint = EndPoint.getUsersReviews(token: token)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/user/review", "Path should be /user/review")
        XCTAssertEqual(endpoint.methodType, .GET(token: token), "The method type should be GET with token")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/user/review", "The generated URL doesn't match our endpoint")
    }

    
    
    func test_newReview_endpoint_request_is_valid() {
        let token = "test-token"
        let submissionData: Data? = nil
        let endpoint = EndPoint.newReview(token: token, submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/teacher/review", "Path should be /teacher/review")
        XCTAssertEqual(endpoint.methodType, .POST(token: token, data: submissionData), "The method type should be POST with token and data")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/teacher/review", "The generated URL doesn't match our endpoint")
    }

    func test_image_endpoint_request_is_valid() {
        let token = "test-token"
        let submissionData: Data? = nil
        let endpoint = EndPoint.image(token: token, submissionData: submissionData)
        
        XCTAssertEqual(endpoint.url?.host, "localhost", "Host should be localhost")
        XCTAssertEqual(endpoint.path, "/image", "Path should be /image")
        XCTAssertEqual(endpoint.methodType, .POSTImg(token: token, data: submissionData), "The method type should be POSTImg with token and data")
        XCTAssertNil(endpoint.queryItems, "Query items should be nil")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "http://localhost:4000/image", "The generated URL doesn't match our endpoint")
    }

}



