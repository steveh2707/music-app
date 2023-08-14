//
//  BookingVM.swift
//  MusicApp
//
//  Created by Steve on 29/06/2023.
//

import Foundation




class BookingVM: ObservableObject {
    
    @Published var teacher: Teacher
    @Published var teacherAvailability: TeacherAvailability? = nil
    @Published var searchDate = Date(mySqlDateString: "2023-09-09T00:00:00.000Z")
    
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
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared, teacher: Teacher) {
        self.networkingManager = networkingManager
        self.teacher = teacher
    }
    
    @MainActor
    func getTeacherAvailability(token: String?) async {
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            self.searchedDates = [searchDate.addOrSubtractDays(day: -1),
                                  searchDate,
                                  searchDate.addOrSubtractDays(day: 1)]
            
            self.teacherAvailability = try await networkingManager.request(session: .shared,
                                                                           .teacherAvailability(token: token, id: teacher.teacherID, startDate: searchedDates[0], endDate: searchDate.addOrSubtractDays(day: 2)),
                                                                           type: TeacherAvailability.self)

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
    func makeBooking(token: String?, instrumentId: Int, gradeId: Int, priceFinal: Double) async {
        
        do {
            submissionState = .submitting
            
//            let newBooking = NewBooking(teacherId: teacher.teacherID, date: selectedDate, startTime: selectedTime, endTime: selectedTime, instrumentId: instrumentId, gradeId: gradeId, priceFinal: priceFinal)
            
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
    
}
