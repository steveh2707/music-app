//
//  TeacherScheduleModel.swift
//  MusicApp
//
//  Created by Steve on 24/08/2023.
//

import Foundation

// MARK: - TeacherScheduleApiResponse
/// Data model for API response for teachers schedule
struct TeacherScheduleApiResponse: Codable {
    let results: [AvailabilitySlot]
}

// MARK: - AvailabilitySlot
/// Data model for each availability timeslot
struct AvailabilitySlot: Codable, Hashable {
    
    let teacherAvailabilityID: Int
    var parsedStartTime: Date
    var parsedEndTime: Date

    enum CodingKeys: String, CodingKey {
        case teacherAvailabilityID = "teacher_availability_id"
        case parsedStartTime = "start_time"
        case parsedEndTime = "end_time"
    }

    init(date: Date = Date()) {
        let roundedDateTimeStart = date.nearestHour()
        self.teacherAvailabilityID = 0
        self.parsedStartTime =  roundedDateTimeStart
        self.parsedEndTime = roundedDateTimeStart.addOrSubtractMinutes(minutes: 60)
    }
    
    init(teacherAvailabilityID: Int, startTime: Date, endTime: Date) {
        self.teacherAvailabilityID = teacherAvailabilityID
        self.parsedStartTime =  startTime
        self.parsedEndTime = endTime
    }
    
    init(teacherAvailabilityID: Int, startTime: String, endTime: String) {
        self.teacherAvailabilityID = teacherAvailabilityID
        self.parsedStartTime =  Date(mySqlDateTimeString: startTime)
        self.parsedEndTime = Date(mySqlDateTimeString: endTime)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.teacherAvailabilityID = try container.decode(Int.self, forKey: .teacherAvailabilityID)
        self.parsedStartTime = Date(mySqlDateTimeString: try container.decode(String.self, forKey: .parsedStartTime))
        self.parsedEndTime = Date(mySqlDateTimeString: try container.decode(String.self, forKey: .parsedEndTime))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(teacherAvailabilityID, forKey: .teacherAvailabilityID)
        try container.encode(parsedStartTime.asSqlDateTimeString(), forKey: .parsedStartTime)
        try container.encode(parsedEndTime.asSqlDateTimeString(), forKey: .parsedEndTime)
    }
}

