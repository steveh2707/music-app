//
//  BookingModel.swift
//  MusicApp
//
//  Created by Steve on 29/06/2023.
//

import Foundation


// MARK: - Welcome
struct TeacherAvailability: Codable, Equatable {
    let teacherID: Int
    let availability: [Availability]

    enum CodingKeys: String, CodingKey {
        case teacherID = "teacher_id"
        case availability
    }
}

// MARK: - Availability
struct Availability: Codable, Identifiable, Equatable {
    var id: UUID { UUID() }
    let date: String
    let slots, bookings: [Booking]
}

// MARK: - Booking
struct Booking: Codable, Equatable {
    let startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
    }
}
