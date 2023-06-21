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
    let firstName, lastName, tagline, bio: String
    let locationLatitude, locationLongitude: Double
    let profileImageURL: String?
    let instrumentsTaught: [InstrumentTaught]
    let reviews: [Review]
    let averageReviewScore: Double

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case teacherID = "teacher_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case tagline
        case bio
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case profileImageURL = "profile_image_url"
        case instrumentsTaught = "instruments_taught"
        case reviews
        case averageReviewScore = "average_review_score"
    }
}

// MARK: - InstrumentsTaught
struct InstrumentTaught: Codable, Identifiable {
    let id: Int
    let instrumentID: Int
    let instrumentName: String
    let sfSymbol: String
    let gradeID: Int
    let gradeName: String

    enum CodingKeys: String, CodingKey {
        case id
        case instrumentID = "instrument_id"
        case instrumentName = "instrument_name"
        case sfSymbol = "sf_symbol"
        case gradeID = "grade_id"
        case gradeName = "grade_name"
    }
}

// MARK: - Review
struct Review: Codable, Identifiable {
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
    }
    
    var id: Int { userID }
}



struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    let latitude: Double
    let longitude: Double
}
