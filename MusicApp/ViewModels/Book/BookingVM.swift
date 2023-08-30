//
//  BookingVM.swift
//  MusicApp
//
//  Created by Steve on 29/06/2023.
//

import Foundation

/// View model for handling all business logic of bookingScheduleView
class BookingVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var teacher: Teacher
    @Published var teacherAvailability: TeacherAvailability? = nil
    @Published var searchDate: Date
    
    @Published var searchedDates: [Date] = []
    @Published var selectedDateTime: Date?
    
    @Published var viewState: ViewState?
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    @Published var showSuccessMessage = false
    @Published var showInfoPage = false
    @Published var showMakeBookingView = false
    
    private let networkingManager: NetworkingManagerImpl!
    
    // MARK: INITALIZATION
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared, teacher: Teacher) {
        self.networkingManager = networkingManager
        self.teacher = teacher
        
        let calendar = Calendar.current
        let today = Date()
        let midnight = calendar.startOfDay(for: today)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!
        
        self.searchDate = tomorrow
    }
    
    @MainActor
    /// Function to interface with API and assign teachers availability slots to local variable
    /// - Parameter token: JWT token provided to user at login for authentication
    func getTeacherAvailability(token: String?) async {
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            // set search dates as selected date +/- 1 day
            self.searchedDates = [searchDate.addOrSubtractDays(day: -1),
                                  searchDate,
                                  searchDate.addOrSubtractDays(day: 1)]
            
            // make network call using endpoint enum and assign to teacherAvailability variable
            self.teacherAvailability = try await networkingManager.request(session: .shared,
                                                                           .teacherAvailability(token: token, id: teacher.teacherID, startDate: searchedDates[0], endDate: searchDate.addOrSubtractDays(day: 2)),
                                                                           type: TeacherAvailability.self)
            
        } catch {
            // if error is caused by user cancelling request before completed, end function
            if let errorCode = (error as NSError?)?.code, errorCode == NSURLErrorCancelled {
                return
            }
            
            // set hasError variable to true and assign error thrown to error variable to displayed to user
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    
    @MainActor
    /// Sends request to API to create new booking.
    /// - Parameters:
    ///   - token: JWT provided on sign in. Used to identify user making booking.
    ///   - instrumentId: Id of instrument associated with booking
    ///   - gradeId: Id of grade associated with booking
    ///   - priceFinal: Price of lesson
    func makeBooking(token: String?, instrumentId: Int, gradeId: Int, priceFinal: Int) async {
        
        do {
            submissionState = .submitting

            let newBooking = NewBooking(teacherId: teacher.teacherID, startDateTime: selectedDateTime ?? Date(), instrumentId: instrumentId, gradeId: gradeId, priceFinal: priceFinal)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(newBooking)
            
            try await networkingManager.request(session: .shared,
                                                .makeBooking(token: token ?? "", submissionData: data))
            
            submissionState = .successful
            showSuccessMessage = true
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
    
    
    /// Function to return an array each hour between a start and end time
    /// - Parameters:
    ///   - startTime: start time of array
    ///   - endTime: end time of array
    /// - Returns: array of each hour between start and end time
    func getHoursBetweenTwoDates(startTime: Date, endTime: Date) -> [Date] {
        var dates: [Date] = []
        var nextStartTime = startTime
        
        while nextStartTime < endTime {
            dates.append(nextStartTime)
            nextStartTime = Calendar.current.date(byAdding: .hour, value: 1, to: nextStartTime)!
        }
        return dates
    }
    
}
