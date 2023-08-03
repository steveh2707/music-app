//
//  TeachersReviewsVM.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import Foundation

class TeacherReviewsVM: ObservableObject {
    
    @Published var reviews: [Review] = []
    
    @Published var viewState: ViewState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    

    @MainActor
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
