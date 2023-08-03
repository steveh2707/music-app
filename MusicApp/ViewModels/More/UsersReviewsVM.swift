//
//  ReviewVM.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import Foundation

class UsersReviewsVM: ObservableObject {
    
    @Published var reviews: [Review] = []
    
    @Published var viewState: ViewState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    

    @MainActor
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




struct ReviewResults: Codable {
    let numResults, page, totalPages: Int
    let results: [Review]

    enum CodingKeys: String, CodingKey {
        case numResults = "num_results"
        case page
        case totalPages = "total_pages"
        case results
    }
}
