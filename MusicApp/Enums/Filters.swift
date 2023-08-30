//
//  Filters.swift
//  MusicApp
//
//  Created by Steve on 10/07/2023.
//

import Foundation

/// Enum for various filter options for exisiting bookings
enum BookingFilter : String, CaseIterable {
    case upcoming = "Upcoming"
    case past = "Past"
    case all = "All"
}
