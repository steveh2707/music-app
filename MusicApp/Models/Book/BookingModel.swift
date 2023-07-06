//
//  BookingModel.swift
//  MusicApp
//
//  Created by Steve on 29/06/2023.
//

import Foundation


struct NewBooking: Codable {
    var teacherId: Int
    var date: String
    var startTime: String
    var endTime: String
    var instrumentId: Int
    var gradeId: Int
    var priceFinal: Double
    
    init(teacherId: Int, date: String?, startTime: String?, endTime: String?, instrumentId: Int, gradeId: Int, priceFinal: Double) {
        self.teacherId = teacherId
        self.date = date ?? ""
        self.startTime = startTime ?? ""
//        self.endTime = getEndTime(startTime: startTime ?? "")
        self.instrumentId = instrumentId
        self.gradeId = gradeId
        self.priceFinal = priceFinal
        
        let startTimeInt = Int(startTime?.prefix(2) ?? "") ?? 0
        let endTimeInt = startTimeInt + 1
        let endTimeString = String(endTimeInt) + ":00"
        
        self.endTime = endTimeString
    }
    
    enum CodingKeys: String, CodingKey {
        case teacherId = "teacher_id"
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case instrumentId = "instrument_id"
        case gradeId = "grade_id"
        case priceFinal = "price_final"
    }
    
    func getEndTime(startTime: String) -> String {
        let startTimeInt = Int(startTime.prefix(2)) ?? 0
        let endTimeInt = startTimeInt + 1
        let endTimeString = String(endTimeInt) + ":00"
        
        return endTimeString
    }
}


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


