//
//  ChatVM.swift
//  MusicApp
//
//  Created by Steve on 21/06/2023.
//

import Foundation

/// View model for handling all business logic of chat view
class ChatVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var chat: ChatDetails? = nil
    @Published var newMessage = NewMessage()
    
    @Published var viewState: ViewState?
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to interface with API and get chat details using either chat ID or teacher ID and assign to local variable
    /// - Parameters:
    ///   - chatID: ID of chat
    ///   - teacherID: ID of teacher in chat
    ///   - token: JWT token provided to user at login for authentication
    func searchForChatUsingChatIdOrTeacherId(chatID: Int?, teacherID: Int?, token: String?) async {
        
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            var decodedResponse: ChatDetails
            if let chatID {
                decodedResponse = try await NetworkingManager.shared.request(.chat(token: token, id: chatID), type: ChatDetails.self)
            } else {
                decodedResponse = try await NetworkingManager.shared.request(.chatFromTeacherId(token: token, id: teacherID ?? 0), type: ChatDetails.self)
            }
            self.chat = decodedResponse
            
        } catch {
            
            if let errorCode = (error as NSError?)?.code, errorCode == NSURLErrorCancelled {
                return
            }
            
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    /// Function to interface with API to send a chat message
    /// - Parameters:
    ///   - token: JWT token provided to user at login for authentication
    func sendChatMessage(token: String?) async {
        do {
            submissionState = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(newMessage)
            
            let decodedResponse = try await NetworkingManager.shared.request(.newMessage(token: token ?? "", chatId: chat?.chatID ?? 0, submissionData: data), type: Message.self)
            self.chat?.messages.append(decodedResponse)
            
            submissionState = .successful
            
        } catch {
            self.hasError = true
            self.submissionState = .unsuccessful
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }

    
}
