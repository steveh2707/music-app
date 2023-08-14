//
//  TeacherVM.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation
import MapKit


class TeacherVM: ObservableObject {
    
    @Published var teacher: Teacher? = nil
    @Published var mapLatitude: Double = 0
    @Published var mapLongitude: Double = 0
    @Published var favTeacher: Bool = false
    @Published var hasAppeared = false
    
    @Published var viewState: ViewState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    
    @MainActor
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
