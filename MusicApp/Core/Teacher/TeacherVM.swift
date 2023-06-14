//
//  TeacherVM.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation


class TeacherVM: ObservableObject {
    
    @Published var teacherDetails: TeacherDetails? = nil
    @Published var error: NetworkingManager.NetworkingError?
    @Published var hasError = false
    @Published var isLoading = false
    
    @MainActor
    func getTeacherDetails(teacherId: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.teacherDetails = try await NetworkingManager.shared.request(.teacher(id: teacherId), type: TeacherDetails.self)
            
        } catch {
            
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
}
