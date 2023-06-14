//
//  TeacherDetails.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation


// MARK: - Welcome
struct TeacherDetails: Codable {
    let userID, teacherID: Int
    let firstName, lastName, bio: String
    let locationLatitude, locationLongitude: Double
    let imageURL: String
    let instrumentsTaught: [InstrumentTaught]
    let reviews: [Review]?
    let averageReviewScore: Double

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case teacherID = "teacher_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case imageURL = "image_url"
        case instrumentsTaught = "instruments_taught"
        case reviews
        case averageReviewScore = "average_review_score"
    }
}

// MARK: - InstrumentsTaught
struct InstrumentTaught: Codable {
    let instrumentID: Int
    let instrumentName: String
    let gradeID: Int
    let gradeName: String

    enum CodingKeys: String, CodingKey {
        case instrumentID = "instrument_id"
        case instrumentName = "instrument_name"
        case gradeID = "grade_id"
        case gradeName = "grade_name"
    }
}

// MARK: - Review
struct Review: Codable {
    let reviewID: Int
    let numStars: Double
    let createdTimestamp, details: String
    let studentID: Int
    let firstName, lastName: String
    let instrumentID: Int
    let instrumentName: String
    let gradeID: Int
    let gradeName: String

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case numStars = "num_stars"
        case createdTimestamp = "created_timestamp"
        case details
        case studentID = "student_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case instrumentID = "instrument_id"
        case instrumentName = "instrument_name"
        case gradeID = "grade_id"
        case gradeName = "grade_name"
    }
}
