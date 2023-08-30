//
//  BecomeTeacherModel.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import Foundation

// MARK: - NewTeacher
/// Data model for a new teacher signing up
struct NewTeacher: Encodable {
    var tagline: String = ""
    var bio: String = ""
    var lattitude: Double = 0.0
    var longtitude: Double = 0.0
    
    var instrumentsTeachable = [InstrumentTeachable]()
}

// MARK: - InstrumentTeachable
/// Data model for instruments teachable by new teacher
struct InstrumentTeachable: Encodable {
    var gradeId: Int = 0
    var instrumentId: Int = 0
}
