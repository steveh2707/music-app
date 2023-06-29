//
//  ChatVM.swift
//  MusicApp
//
//  Created by Steve on 21/06/2023.
//

import Foundation

struct NewMessage: Codable {
    var message = ""
}


class ChatVM: ObservableObject {
    
    @Published var chat: Chat? = nil
    @Published var newMessage = NewMessage()
    
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    @MainActor
    func searchForChat(teacherId: Int, token: String?) async {
        do {
            state = .submitting
            
            let decodedResponse = try await NetworkingManager.shared.request(.chat(id: teacherId, token: token), type: Chat.self)
            self.chat = decodedResponse
            
            state = .successful
        } catch {
            self.hasError = true
            self.state = .unsuccessful
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    func sendChatMessage(teacherId: Int, token: String?) async {
        do {
//            state = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(newMessage)
            
            let decodedResponse = try await NetworkingManager.shared.request(.newMessage(chatId: chat?.chatID ?? 0, token: token ?? "", submissionData: data), type: Message.self)
            self.chat?.messages.append(decodedResponse)
            
//            state = .successful
        } catch {
            self.hasError = true
//            self.state = .unsuccessful
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }

    
}
