//
//  BookingDetailVM.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import Foundation

class BookingDetailVM: ObservableObject {
    
    @Published var bookingDetail: UserBooking
    @Published var review: NewReview
    @Published var cancelReason = ""
    
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    @Published var showBookingCancelledMessage = false
    
    init(bookingDetail: UserBooking) {
        self.bookingDetail = bookingDetail
        self.review = NewReview(teacherId: bookingDetail.teacherID, rating: 0, details: "", gradeId: bookingDetail.grade.gradeID, instrumentId: bookingDetail.instrument.instrumentID)
    }
    
    @MainActor
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
