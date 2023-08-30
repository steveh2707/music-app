//
//  TeacherScheduleVM.swift
//  MusicApp
//
//  Created by Steve on 24/08/2023.
//

import Foundation

/// View model for handling all business logic of Teacher Schedule View
class TeacherScheduleVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var date = Date()
    @Published var slot: AvailabilitySlot?
    @Published var allSlots: [AvailabilitySlot] = []
    
    var selectedDaySlots: [AvailabilitySlot] {
        allSlots.filter { Calendar.current.isDate($0.parsedStartTime, inSameDayAs: date) }
    }
    
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
    /// Function to interface with API to fetch teacher's schedule and assign to local variable
    /// - Parameter token: JWT token provided to user at login for authentication
    func fetchSchedule(token: String?) async {
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            let decodedResponse = try await networkingManager.request(session: .shared, .teacherSchedule(token: token), type: TeacherScheduleApiResponse.self)

            self.allSlots = decodedResponse.results
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
