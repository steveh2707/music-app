//
//  AllChatsVM.swift
//  MusicApp
//
//  Created by Steve on 23/06/2023.
//

import Foundation

class AllChatsVM: ObservableObject {
    
    @Published var chats: [ChatResult] = []
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    
    @MainActor
    func getChats(token: String?) async {
       
        do {
            state = .submitting
            
            let decodedResponse = try await NetworkingManager.shared.request(.allChats(token: token), type: AllChatsResponse.self)
            self.chats = decodedResponse.results
            
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
    
}
