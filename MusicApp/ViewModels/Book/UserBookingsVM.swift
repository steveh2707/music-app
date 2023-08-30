//
//  UserBookingsVM.swift
//  MusicApp
//
//  Created by Steve on 07/07/2023.
//

import Foundation

/// View model for handling all business logic of User Bookings View
class UserBookingsVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var bookings: [UserBooking] = []
    @Published var bookingDetail: UserBooking?
    
    @Published var viewState: ViewState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    @Published var showBookingCancelledMessage = false
    
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to interface with API and assign bookings to local variable
    /// - Parameter token: JWT token provided to user at login for authentication
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
    
}


