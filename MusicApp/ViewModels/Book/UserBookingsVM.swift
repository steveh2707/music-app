//
//  UserBookingsVM.swift
//  MusicApp
//
//  Created by Steve on 07/07/2023.
//

import Foundation

class UserBookingsVM: ObservableObject {
    
    @Published var bookings: [UserBooking] = []
    @Published var bookingDetail: UserBooking?
    @Published var cancelReason = ""
    
    @Published var viewState: ViewState?
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    @Published var showBookingCancelledMessage = false
    
    @MainActor
    func getBookings(token: String?) async {
        
        viewState = .fetching
        defer { viewState = .finished }
       
        do {
            
            let decodedResponse = try await NetworkingManager.shared.request(.allBookings(token: token), type: UserBookingsResponse.self)
            self.bookings = decodedResponse.results
            
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
    func cancelBooking(token: String?) async {
        do {
            submissionState = .submitting
            
            let cancelReason = CancelBooking(cancelReason: cancelReason)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(cancelReason)
            
            try await NetworkingManager.shared.request(.cancelBooking(token: token, bookingId: bookingDetail?.bookingID ?? 0, submissionData: data))
            
            submissionState = .successful
            showBookingCancelledMessage = true
            
            await getBookings(token: token)
            
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


struct CancelBooking: Codable {
    let cancelReason: String
    
    enum CodingKeys: String, CodingKey {
        case cancelReason = "cancel_reason"
    }
    
}
