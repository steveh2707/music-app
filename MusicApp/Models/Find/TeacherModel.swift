//
//  TeacherDetails.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation


// MARK: - Welcome
struct Teacher: Codable, Equatable {
    
    let userID, teacherID: Int
    let firstName, lastName, tagline, bio, locationTitle: String
    let locationLatitude, locationLongitude: Double
    let profileImageURL: String?
    let instrumentsTaught: [InstrumentTaught]
    let reviews: [Review]
    let averageReviewScore: Double
    
    var fullName: String {
        firstName + " " + lastName
    }

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case teacherID = "teacher_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case tagline
        case bio
        case locationTitle = "location_title"
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case profileImageURL = "profile_image_url"
        case instrumentsTaught = "instruments_taught"
        case reviews
        case averageReviewScore = "average_review_score"
    }
}

// MARK: - InstrumentsTaught
struct InstrumentTaught: Codable, Identifiable, Equatable, Hashable {
    var id: Int {
        teacherInstrumentTaughtId
    }
    
    let teacherInstrumentTaughtId: Int
    let instrumentID: Int
    let instrumentName: String
    let sfSymbol: String
    let gradeID: Int
    let gradeName: String
    let lessonCost: Int
    let rank: Int?

    enum CodingKeys: String, CodingKey {
        case teacherInstrumentTaughtId = "teacher_instrument_taught_id"
        case instrumentID = "instrument_id"
        case instrumentName = "instrument_name"
        case sfSymbol = "sf_symbol"
        case gradeID = "grade_id"
        case gradeName = "grade_name"
        case lessonCost = "lesson_cost"
        case rank
    }
}




// MARK: - Review
struct Review: Codable, Identifiable, Equatable {
    let reviewID: Int
    let numStars: Int
    let createdTimestamp, details: String
    let userID: Int
    let firstName, lastName: String
    let instrumentID: Int
    let instrumentName: String
    let sfSymbol: String
    let gradeID: Int
    let gradeName: String
    let profileImageUrl: String

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case numStars = "num_stars"
        case createdTimestamp = "created_timestamp"
        case details
        case userID = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case instrumentID = "instrument_id"
        case instrumentName = "instrument_name"
        case sfSymbol = "sf_symbol"
        case gradeID = "grade_id"
        case gradeName = "grade_name"
        case profileImageUrl = "profile_image_url"
    }
    
    var id: Int { reviewID }
    var fullName: String { firstName + " " + lastName }
}


struct TeacherFavourite: Codable {
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}


