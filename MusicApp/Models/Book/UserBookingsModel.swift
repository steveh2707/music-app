//
//  UserBookingsModel.swift
//  MusicApp
//
//  Created by Steve on 07/07/2023.
//

import Foundation


// MARK: - Welcome
struct UserBookingsResponse: Codable {
    let results: [UserBooking]
}

// MARK: - Result
struct UserBooking: Codable, Identifiable {
    var id: Int { bookingID }
    var formattedDate: Date { Date(mySqlDateTimeString: date) }
    
    let bookingID: Int
    let dateCreated, date, startTime, endTime: String
    let priceFinal, cancelled: Int
    let cancelReason: String?
    let studentID, teacherID: Int
    let student, teacher: UserSimple
    let instrument: BookingInstrument
    let grade: BookingGrade

    enum CodingKeys: String, CodingKey {
        case bookingID = "booking_id"
        case dateCreated = "date_created"
        case date
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


// MARK: - Grade
struct BookingGrade: Codable {
    let gradeID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case gradeID = "grade_id"
        case name
    }
}

// MARK: - Instrument
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

// MARK: - Student
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
