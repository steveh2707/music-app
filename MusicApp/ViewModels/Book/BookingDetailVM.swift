//
//  BookingDetailVM.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import Foundation

/// View model for handling all business logic of Booking Detail Modal View
class BookingDetailVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var bookingDetail: UserBooking
    @Published var review: NewReview
    @Published var cancelReason = ""
    
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    @Published var showBookingCancelledMessage = false
    
    // MARK: INITALIZATION
    init(bookingDetail: UserBooking) {
        self.bookingDetail = bookingDetail
        self.review = NewReview(teacherId: bookingDetail.teacherID, rating: 0, details: "", gradeId: bookingDetail.grade.gradeID, instrumentId: bookingDetail.instrument.instrumentID)
    }
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to interface with API and allow user to cancel a booking
    /// - Parameter token: JWT token provided to user at login for authentication
    func cancelBooking(token: String?) async {
        do {
            submissionState = .submitting
            
            let cancelReason = CancelBooking(cancelReason: cancelReason)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(cancelReason)
            
            try await NetworkingManager.shared.request(.cancelBooking(token: token, bookingId: bookingDetail.bookingID, submissionData: data))
            
            submissionState = .successful
            showBookingCancelledMessage = true
            
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
    /// Function to interface with API and post a review of a past lesson
    /// - Parameter token: JWT token provided to user at login for authentication
    func postReview(token: String?) async {
        do {
            submissionState = .submitting
                    
            let encoder = JSONEncoder()
            let data = try encoder.encode(review)
            
            try await NetworkingManager.shared.request(.newReview(token: token, submissionData: data))
            
            submissionState = .successful
            showBookingCancelledMessage = true
            
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
