//
//  SearchResultsModel.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import Foundation


struct SearchCriteria: Encodable {
    var userLatitude: Double?
    var userLongitude: Double?
    var instrumentId: Int?
    var gradeRankId: Int?
    var selectedSort: SearchResultsSort = .avReviewScoreDesc
    
    enum CodingKeys: String, CodingKey {
        case userLatitude = "user_latitude"
        case userLongitude = "user_longitude"
        case instrumentId = "instrument_id"
        case gradeRankId = "grade_rank_id"
        case selectedSort = "selected_sort"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userLatitude, forKey: .userLatitude)
        try container.encode(userLongitude, forKey: .userLongitude)
        try container.encode(instrumentId, forKey: .instrumentId)
        try container.encode(gradeRankId, forKey: .gradeRankId)
        try container.encode(selectedSort.rawValue, forKey: .selectedSort)
    }
}


// MARK: - SearchResults
struct SearchResults: Codable {
    let numResults, page, totalPages: Int
    let results: [TeacherResult]

    enum CodingKeys: String, CodingKey {
        case numResults = "num_results"
        case page
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct TeacherResult: Codable, Identifiable, Hashable {
    var id: Int { teacherID }
    
    let teacherID: Int
    let firstName, lastName, tagline, bio, locationTitle: String
    let locationLatitude, locationLongitude: Double
    let averageReviewScore: Double
    let profileImageURL: String
    let instrumentTeachable: InstrumentTaught?
    let distanceInKM: Double?

    enum CodingKeys: String, CodingKey {

        case teacherID = "teacher_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case tagline, bio
        case locationTitle = "location_title"
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case averageReviewScore = "average_review_score"
        case profileImageURL = "profile_image_url"
        case instrumentTeachable = "instrument_teachable"
        case distanceInKM = "distance_in_km"
    }

    var fullName: String { firstName + " " + lastName }
}


