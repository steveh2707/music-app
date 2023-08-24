//
//  BookingModel.swift
//  MusicApp
//
//  Created by Steve on 29/06/2023.
//

import Foundation


struct NewBooking: Codable {
    var teacherId: Int
    var startTime: String
    var endTime: String
    var instrumentId: Int
    var gradeId: Int
    var priceFinal: Int
    
    init(teacherId: Int, startDateTime: Date, instrumentId: Int, gradeId: Int, priceFinal: Int) {
        self.teacherId = teacherId
        self.instrumentId = instrumentId
        self.gradeId = gradeId
        self.priceFinal = priceFinal
        
        self.startTime = startDateTime.asSqlDateTimeString()
        self.endTime = startDateTime.addOrSubtractMinutes(minutes: 60).asSqlDateTimeString()
        

    }
    
    enum CodingKeys: String, CodingKey {
        case teacherId = "teacher_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case instrumentId = "instrument_id"
        case gradeId = "grade_id"
        case priceFinal = "price_final"
    }
    
}


// MARK: - TeacherAvailability Model
struct TeacherAvailability: Codable, Equatable {
    let teacherID: Int
    let slots, bookings: [TimeSlot]
    
    enum CodingKeys: String, CodingKey {
        case teacherID = "teacher_id"
        case slots, bookings
    }
}


// MARK: - TimeSlot
struct TimeSlot: Codable, Equatable, Identifiable {
    let id = UUID()
    
    let startTime, endTime: String
    var parsedStartTime: Date { Date(mySqlDateTimeString: startTime) }
    var parsedEndTime: Date { Date(mySqlDateTimeString: endTime) }

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
    }
}


