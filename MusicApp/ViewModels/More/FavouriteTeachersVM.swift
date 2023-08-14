//
//  FavouriteTeachersVM.swift
//  MusicApp
//
//  Created by Steve on 14/08/2023.
//

import Foundation

class FavouriteTeacherVM: ObservableObject {
    
    @Published var teachers: [TeacherResult] = []
    
    @Published var viewState: ViewState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private(set) var page = 1
    private(set) var totalPages: Int?
    private(set) var totalResults: Int?
    private(set) var data: Data?
    
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    @MainActor
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
    
    
    func reset() {
        if viewState == .finished {
            teachers.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
    
    func shouldLoadData(id: Int) -> Bool {
        return id == teachers.last?.id && page != totalPages && viewState == .finished
    }
}
