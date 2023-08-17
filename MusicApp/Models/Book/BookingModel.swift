//
//  BookingModel.swift
//  MusicApp
//
//  Created by Steve on 29/06/2023.
//

import Foundation


struct NewBooking: Codable {
    var teacherId: Int
//    var date: String
    var startTime: String
    var endTime: String
    var instrumentId: Int
    var gradeId: Int
    var priceFinal: Int
    
//    init(teacherId: Int, date: String?, startTime: String?, endTime: String?, instrumentId: Int, gradeId: Int, priceFinal: Double) {
//        self.teacherId = teacherId
//        self.date = date ?? ""
//        self.startTime = startTime ?? ""
////        self.endTime = getEndTime(startTime: startTime ?? "")
//        self.instrumentId = instrumentId
//        self.gradeId = gradeId
//        self.priceFinal = priceFinal
//        
//        let startTimeInt = Int(startTime?.prefix(2) ?? "") ?? 0
//        let endTimeInt = startTimeInt + 1
//        let endTimeString = String(endTimeInt) + ":00"
//        
//        self.endTime = endTimeString
//    }
  
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
//        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case instrumentId = "instrument_id"
        case gradeId = "grade_id"
        case priceFinal = "price_final"
    }
    
//    func getEndTime(startTime: String) -> String {
//        let startTimeInt = Int(startTime.prefix(2)) ?? 0
//        let endTimeInt = startTimeInt + 1
//        let endTimeString = String(endTimeInt) + ":00"
//        
//        return endTimeString
//    }
}


// MARK: - Welcome
struct TeacherAvailability: Codable, Equatable {
    let teacherID: Int
//    let availability: [Availability]
    let slots, bookings: [ExistingBooking]
    
    enum CodingKeys: String, CodingKey {
        case teacherID = "teacher_id"
        case slots, bookings
    }
    

    
//    var parsedDate: Date { Date(mySqlDateString: date )}
}

// MARK: - Availability
//struct Availability: Codable, Identifiable, Equatable {
//    var id: UUID { UUID() }
//    let date: String
//    let slots, bookings: [ExistingBooking]
//
//    var parsedDate: Date { Date(mySqlDateString: date )}
//}

// MARK: - Booking
struct ExistingBooking: Codable, Equatable, Identifiable {
    let id = UUID()
    
    let startTime, endTime: String
    var parsedStartTime: Date { Date(mySqlDateTimeString: startTime) }
    var parsedEndTime: Date { Date(mySqlDateTimeString: endTime) }

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
    }
}


