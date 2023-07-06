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
    @Published var searchDate = Date(mySqlDateTimeString: "2023-09-06T12:00:00.000Z")
    
    @Published var searchedDates: [Date] = []
    @Published var selectedDate: String?
    @Published var selectedTime: String?
    
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared, teacher: Teacher) {
        self.networkingManager = networkingManager
        self.teacher = teacher
    }
    
    @MainActor
    func getTeacherAvailability(teacherId: Int) async {
        
        do {
            state = .submitting
            
            self.teacherAvailability = try await networkingManager.request(session: .shared,
                                                                           .teacherAvailability(id: teacherId, date: searchDate.asSqlDateString()),
                                                                           type: TeacherAvailability.self)
            searchedDates = [searchDate.addOrSubtractDays(day: -1),
                             searchDate,
                             searchDate.addOrSubtractDays(day: 1)
            ]
            
            state = .successful
        } catch {
            self.hasError = true
            self.state = .unsuccessful
            
            print(error)
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
}
