//
//  TeachersReviewsVM.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import Foundation

/// View model for handling all business logic of Teachers Reviews View
class TeacherReviewsVM: ObservableObject {
    
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
    /// Function to interface with API to get teachers reviews and assign to local variable
    /// - Parameter teacherId: Id of teacher
    func getReviews(teacherId: Int) async {
        
        viewState = .fetching
        defer { viewState = .finished }
        
        do {

            let decodedResponse = try await networkingManager.request(session: .shared,
                                                                      .getTeachersReviews(id: teacherId),
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
