//
//  TeacherVM.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation
import MapKit

/// View model for handling all business logic of Teacher View
class TeacherVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var teacher: Teacher? = nil
    @Published var mapLatitude: Double = 0
    @Published var mapLongitude: Double = 0
    @Published var favTeacher: Bool = false
    @Published var hasAppeared = false
    
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
    /// Function to interface with API and assign teacher to local variable
    /// - Parameter teacherId: ID of teacher being searched for
    func getTeacherDetails(teacherId: Int) async {
        if hasAppeared { return }
        
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            
            self.teacher = try await networkingManager.request(session: .shared,
                                                               .teacher(id: teacherId),
                                                               type: Teacher.self)
            mapLatitude = teacher?.locationLatitude ?? 0
            mapLongitude = teacher?.locationLongitude ?? 0
            hasAppeared = true
            
        } catch {
            
            if let errorCode = (error as NSError?)?.code, errorCode == NSURLErrorCancelled { return }
            
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    /// Function to interface with API to check whether user has favourited teacher
    /// - Parameters:
    ///   - token: JWT token provided to user at login for authentication
    ///   - teacherId: ID of teacher to check
    func checkIfTeacherHasBeenFavourited(token: String?, teacherId: Int) async {
        do {
            let decodedResponse = try await networkingManager.request(session: .shared,
                                                                      .isTeacherFavourited(token: token, id: teacherId),
                                                                      type: TeacherFavourite.self)
            if decodedResponse.count > 0 {
                favTeacher = true
            }
        } catch {
            
            if let errorCode = (error as NSError?)?.code, errorCode == NSURLErrorCancelled { return }
            
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    /// Function to interface with API to handle favouriting and unfavouriting teachers.
    /// - Parameters:
    ///   - token: JWT token provided to user at login for authentication
    ///   - teacherId: ID of teacher to favourite
    func favouriteTeacher(token: String?, teacherId: Int) async {
        do {
            if favTeacher {
                try await networkingManager.request(session: .shared,
                                                    .unfavouriteTeacher(token: token, id: teacherId))
                favTeacher = false
            } else {
                try await networkingManager.request(session: .shared,
                                                    .favouriteTeacher(token: token, id: teacherId))
                favTeacher = true
            }
        } catch {

            if let errorCode = (error as NSError?)?.code, errorCode == NSURLErrorCancelled { return }
            
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }

}
