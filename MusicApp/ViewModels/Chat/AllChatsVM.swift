//
//  AllChatsVM.swift
//  MusicApp
//
//  Created by Steve on 23/06/2023.
//

import Foundation

/// View model for handling all business logic of
class AllChatsVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var chats: [ChatGeneral] = []
    
    @Published var viewState: ViewState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to interface with API and assign chats to local variable
    /// - Parameter token: JWT token provided to user at login for authentication
    func getChats(token: String?) async {
        
        viewState = .fetching
        defer { viewState = .finished }
       
        do {
            // interact with API and assign response to decodedResponse variable
            let decodedResponse = try await NetworkingManager.shared.request(.allChats(token: token), type: AllChatsResponse.self)
            self.chats = decodedResponse.results
                        
        } catch {
            // ignore error from cancellation by user
            if let errorCode = (error as NSError?)?.code, errorCode == NSURLErrorCancelled { return }
            
            // assign any other error to local error variable to be displayed to user
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    

    
}
