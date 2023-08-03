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
    
    @Published var viewState: ViewState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    
    @MainActor
    func getTeacherDetails(teacherId: Int) async {
        
        viewState = .fetching
        defer { viewState = .finished }
        
        do {

            self.teacher = try await networkingManager.request(session: .shared,
                                                                      .teacher(id: teacherId),
                                                                      type: Teacher.self)
            mapLatitude = teacher?.locationLatitude ?? 0
            mapLongitude = teacher?.locationLongitude ?? 0
            
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
