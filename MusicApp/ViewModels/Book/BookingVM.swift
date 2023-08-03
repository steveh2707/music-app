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
    @Published var searchDate = Date(mySqlDateTimeString: "2023-09-09T12:00:00.000Z")
    
    @Published var searchedDates: [Date] = []
    @Published var selectedDateTime: Date?
    
    @Published var viewState: ViewState?
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    @Published var showSuccessMessage = false
    
    
    let hours: [String] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    @Published var firstBookingSlot = "23"
    @Published var lastBookingSlot = "00"
    var filteredHours: [String] { hours.filter { $0 >= firstBookingSlot && $0 < lastBookingSlot } }
    
    
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
            self.teacherAvailability = try await networkingManager.request(session: .shared,
                                                                           .teacherAvailability(token: token ?? "", id: teacher.teacherID, date: searchDate.asSqlDateString()),
                                                                           type: TeacherAvailability.self)
            searchedDates = [searchDate.addOrSubtractDays(day: -1),
                             searchDate,
                             searchDate.addOrSubtractDays(day: 1)
            ]
            
            var earliestTimeslot = firstBookingSlot
            var latestTimeSlot = "00"
            for day in teacherAvailability!.availability {
                for timeslot in day.slots {
                    
                    if let startTime = timeslot.parsedStartTime.asHour(), startTime < earliestTimeslot {
                        print(startTime)
                        earliestTimeslot = startTime
                    }
                    if let endTime = timeslot.parsedEndTime.asHour(), endTime > latestTimeSlot {
                        latestTimeSlot = endTime
                    }
                }
            }
            
            self.firstBookingSlot = earliestTimeslot
            self.lastBookingSlot = latestTimeSlot
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
