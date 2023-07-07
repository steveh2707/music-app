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
    let studentID: Int
    let instrumentID: Int?
    let instrumentName, instrumendSfSymbol: String?
    let instrumentImageURL: String?
    let gradeID: Int?
    let gradeName: String?
    let teacherID: Int
    let teacherFirstName, teacherLastName: String
    let teacherProfileImageURL: String?

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
        case instrumentID = "instrument_id"
        case instrumentName = "instrument_name"
        case instrumendSfSymbol = "instrumend_sf_symbol"
        case instrumentImageURL = "instrument_image_url"
        case gradeID = "grade_id"
        case gradeName = "grade_name"
        case teacherID = "teacher_id"
        case teacherFirstName = "teacher_first_name"
        case teacherLastName = "teacher_last_name"
        case teacherProfileImageURL = "teacher_profile_image_url"
    }
}

