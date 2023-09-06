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
    @Published var slot: AvailabilitySlot
    @Published var allSlots: [AvailabilitySlot] = []
    
    var selectedDaySlots: [AvailabilitySlot] {
        allSlots.filter { Calendar.current.isDate($0.parsedStartTime, inSameDayAs: date) }
    }
    
    @Published var viewState: ViewState?
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private let networkingManager: NetworkingManagerImpl!
    
    // MARK: INITALIZATION
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
        self.slot = AvailabilitySlot()
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
    
    @MainActor
    /// Function to interface with API to fetch teacher's schedule and assign to local variable
    /// - Parameter token: JWT token provided to user at login for authentication
    func addOrEditTimeSlot(token: String?) async {

        do {
            submissionState = .submitting

            let encoder = JSONEncoder()
            let data = try encoder.encode(slot)

            let decodedResponse: TeacherScheduleApiResponse
            if slot.teacherAvailabilityID == 0 {
                decodedResponse = try await networkingManager.request(session: .shared, .addTimeSlotToSchedule(token: token, submissionData: data), type: TeacherScheduleApiResponse.self)
            } else {
                decodedResponse = try await networkingManager.request(session: .shared, .editTimeSlotInSchedule(token: token, submissionData: data), type: TeacherScheduleApiResponse.self)
            }
            self.allSlots = decodedResponse.results
            
            self.slot = AvailabilitySlot(date: date)
            submissionState = .successful

        } catch {

            self.hasError = true
            self.submissionState = .unsuccessful

            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    
    @MainActor
    /// Function to interface with API to fetch teacher's schedule and assign to local variable
    /// - Parameter token: JWT token provided to user at login for authentication
    func deleteTimeSlot(token: String?) async {

        do {
            submissionState = .submitting

            let decodedResponse = try await networkingManager.request(session: .shared, .deleteTimeSlotFromSchedule(token: token, id: slot.teacherAvailabilityID), type: TeacherScheduleApiResponse.self)
            
            self.allSlots = decodedResponse.results
            self.slot = AvailabilitySlot(date: date)
            submissionState = .successful

        } catch {

            self.hasError = true
            self.submissionState = .unsuccessful

            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
        

}
