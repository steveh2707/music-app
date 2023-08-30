//
//  FavouriteTeachersVM.swift
//  MusicApp
//
//  Created by Steve on 14/08/2023.
//

import Foundation

/// View model for handling all business logic of Favourite Teachers View
class FavouriteTeacherVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var teachers: [TeacherResult] = []
    
    @Published var viewState: ViewState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private(set) var page = 1
    private(set) var totalPages: Int?
    private(set) var totalResults: Int?
    private(set) var data: Data?
    
    private let networkingManager: NetworkingManagerImpl!
    
    // MARK: INITALIZATION
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to interface with API to find user's favouritre teachers and assign to local variable
    /// - Parameter token: JWT token provided to user at login for authentication
    func fetchFavTeachers(token: String?) async {
        reset()
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            let decodedResponse = try await networkingManager.request(session: .shared, .favouriteTeachers(token: token, page: self.page), type: SearchResults.self)
            
            self.totalPages = decodedResponse.totalPages
            self.totalResults = decodedResponse.numResults
            self.teachers = decodedResponse.results
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
    /// Function to interface with API and append next batch of favourite teachers to existing local array
    func fetchNextSetOfTeachers() async {
        viewState = .fetching
        defer { viewState = .finished }
        
        page += 1
        
        do {
            let decodedResponse = try await networkingManager.request(session: .shared, .search(submissionData: data, page: page), type: SearchResults.self)
            
            self.totalPages = decodedResponse.totalPages
            self.teachers += decodedResponse.results
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    
    /// Function to reset view
    func reset() {
        if viewState == .finished {
            teachers.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
    
    /// Function to check whether the next set of teachers should be loaded to enable infinite scrolling
    /// - Parameter id: id of teacher
    /// - Returns: whether new set of teachers should be loaded
    func shouldLoadData(id: Int) -> Bool {
        return id == teachers.last?.id && page != totalPages && viewState == .finished
    }
}
