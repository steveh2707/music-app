//
//  SearchResultsModel.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import Foundation

struct SearchResults: Codable {
    let numResults: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result
struct Result: Codable, Identifiable {
    let teacherID: Int
    let firstName, lastName, tagline, bio: String
    let locationLatitude, locationLongitude: Double
    let averageReviewScore: Double
    let imageURL: String
    let instrumentID: Int
    let gradeTeachable: String
    let rank: Int
    let distanceInKM: Double

    enum CodingKeys: String, CodingKey {
        case teacherID = "teacher_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case tagline, bio
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case averageReviewScore = "average_review_score"
        case imageURL = "image_url"
        case instrumentID = "instrument_id"
        case gradeTeachable = "grade_teachable"
        case rank
        case distanceInKM = "distance_in_km"
    }
    
    var id: Int { teacherID }
}
