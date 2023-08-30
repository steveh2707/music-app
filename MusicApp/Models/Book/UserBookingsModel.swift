//
//  UserBookingsModel.swift
//  MusicApp
//
//  Created by Steve on 07/07/2023.
//

import Foundation


// MARK: - UserBookingsResponse
/// Data model for API response for user's bookings
struct UserBookingsResponse: Codable {
    let results: [UserBooking]
}

// MARK: - UserBooking
/// Data model for a user's booking
struct UserBooking: Codable, Identifiable {
    var id: Int { bookingID }
    var parsedStartTime: Date { Date(mySqlDateTimeString: startTime) }
    var parsedEndTime: Date { Date(mySqlDateTimeString: endTime) }
    
    let bookingID: Int
    let dateCreated, startTime, endTime: String
    let priceFinal, cancelled: Int
    let cancelReason: String?
    let studentID, teacherID: Int
    let student, teacher: UserSimple
    let instrument: BookingInstrument
    let grade: BookingGrade

    enum CodingKeys: String, CodingKey {
        case bookingID = "booking_id"
        case dateCreated = "date_created"
        case startTime = "start_time"
        case endTime = "end_time"
        case priceFinal = "price_final"
        case cancelled
        case cancelReason = "cancel_reason"
        case studentID = "student_id"
        case teacherID = "teacher_id"
        case student, teacher, instrument, grade
    }
}


// MARK: - BookingGrade
/// Data model for the music grade associated with the booking
struct BookingGrade: Codable {
    let gradeID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case gradeID = "grade_id"
        case name
    }
}

// MARK: - BookingInstrument
/// Data model for the instrument associated with the booking
struct BookingInstrument: Codable {
    let instrumentID: Int
    let name: String
    let imageURL: String
    let sfSymbol: String

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case sfSymbol = "sf_symbol"
        case instrumentID = "instrument_id"
    }
}

// MARK: - UserSimple
/// Data model for user details associated with booking
struct UserSimple: Codable, Equatable {
    let userID: Int
    let lastName, firstName: String
    let s3ImageName: String
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case lastName = "last_name"
        case firstName = "first_name"
        case s3ImageName = "s3_image_name"
        case profileImageURL = "profile_image_url"
    }
    
    var fullName: String {firstName + " " + lastName}
}


// MARK: - NewReview
/// Data model for a new review for a past booking
struct NewReview: Codable {
    let teacherId: Int
    var rating: Int
    var details: String
    let gradeId: Int
    let instrumentId: Int
    
    enum CodingKeys: String, CodingKey {
        case teacherId = "teacher_id"
        case rating, details
        case gradeId = "grade_id"
        case instrumentId = "instrument_id"
    }
}


// MARK: - CancelBooking
/// Data model for cancelling an upcoming booking
struct CancelBooking: Codable {
    let cancelReason: String
    
    enum CodingKeys: String, CodingKey {
        case cancelReason = "cancel_reason"
    }
    
}
