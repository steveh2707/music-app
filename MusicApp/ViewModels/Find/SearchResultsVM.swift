//
//  SearchResultsVM.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import Foundation

/// View model for handling all business logic of Search Results View
class SearchResultsVM: ObservableObject {
    
    
    // MARK: PROPERTIES
    @Published var searchCriteria: SearchCriteria
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
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared, searchCriteria: SearchCriteria) {
        self.networkingManager = networkingManager
        self.searchCriteria = searchCriteria
    }
    
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to interface with API and assign teachers to local variable
    func fetchTeachers() async {
        reset()
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            let encoder = JSONEncoder()
            data = try encoder.encode(searchCriteria)
            
            let decodedResponse = try await networkingManager.request(session: .shared, .search(submissionData: data, page: page), type: SearchResults.self)
            
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
    /// Function to interface with API and append new teachers to existing local array
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
