//
//  BecomeTeacherModel.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import Foundation

struct NewTeacher: Encodable {
    var tagline: String = ""
    var bio: String = ""
    var lattitude: Double = 0.0
    var longtitude: Double = 0.0
    
    var instrumentsTeachable = [InstrumentTeachable]()
}

struct InstrumentTeachable: Encodable {
    var gradeId: Int = 0
    var instrumentId: Int = 0
}
