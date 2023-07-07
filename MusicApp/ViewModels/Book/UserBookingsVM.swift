//
//  UserBookingsVM.swift
//  MusicApp
//
//  Created by Steve on 07/07/2023.
//

import Foundation

class UserBookingsVM: ObservableObject {
    
    @Published var bookings: [UserBooking] = []
    
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    
    @MainActor
    func getBookings(token: String?) async {
       
        do {
            state = .submitting
            
            let decodedResponse = try await NetworkingManager.shared.request(.allBookings(token: token), type: UserBookingsResponse.self)
            self.bookings = decodedResponse.results
            
            state = .successful
            
        } catch {
            self.hasError = true
            self.state = .unsuccessful
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    
    
}
