//
//  ReviewVM.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import Foundation

/// View model for handling all business logic of User Reviews View
class UsersReviewsVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var reviews: [Review] = []
    
    @Published var viewState: ViewState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private let networkingManager: NetworkingManagerImpl!
    
    // MARK: INITALIZATION
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to interface with API to get reviews and assign to local variable
    /// - Parameter token: JWT token provided to user at login for authentication
    func getReviews(token: String?) async {
        
        viewState = .fetching
        defer { viewState = .finished }
        
        do {

            let decodedResponse = try await networkingManager.request(session: .shared,
                                                                      .getUsersReviews(token: token),
                                                                      type: ReviewResults.self)
            reviews = decodedResponse.results
            
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
    
}

