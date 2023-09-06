//
//  LoginModel.swift
//  MusicApp
//
//  Created by Steve on 22/06/2023.
//

import Foundation

// MARK: - NewStudent
/// Data model for a new student signing up
struct NewStudent: Encodable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var inputDob: Date = Date.now
    var tos: Bool = false
    
    var dob: String {
        inputDob.asSqlDateString()
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case inputDob = "input_dob"
        case tos
        case dob
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(dob, forKey: .dob)
    }
}

// MARK: - Credentials
/// Data model for login credentials
struct Credentials: Codable {
    var email: String = ""
    var password: String = ""
}


// MARK: - SignInResponse
/// Data model for the API response for logging in
struct SignInResponse: Codable {
    let token: String
    let userDetails: UserDetails
    let teacherDetails: TeacherDetails?

    enum CodingKeys: String, CodingKey {
        case token
        case userDetails = "user_details"
        case teacherDetails = "teacher_details"
    }
}

// MARK: - UserDetails
/// Data model for users details
struct UserDetails: Codable, Equatable {
    let userID: Int
    var firstName, lastName, email, dob: String
    var registeredTimestamp, profileImageURL: String
    var formattedDob: Date
    var dobOutput: String {
        formattedDob.asSqlDateString()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.dob = try container.decode(String.self, forKey: .dob)
        self.registeredTimestamp = try container.decode(String.self, forKey: .registeredTimestamp)
        self.profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
        self.formattedDob =  Date(mySqlDateTimeString: self.dob)
    }

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email, dob
        case registeredTimestamp = "registered_timestamp"
        case profileImageURL = "profile_image_url"
        case formattedDob = "formatted_dob"
        case dobOutput = "dob_output"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(dobOutput, forKey: .dobOutput)
    }
}

// MARK: - TeacherDetails
/// Data model for users teaching details
struct TeacherDetails: Codable, Equatable {
    let teacherID: Int
    var tagline, bio, locationTitle: String
    var locationLatitude, locationLongitude, averageReviewScore: Double
    var instrumentsTeachable: [InstrumentsTeachable]
    var instrumentsRemovedIds: [Int]
    
    init(teacherID: Int, tagline: String, bio: String, locationTitle: String, locationLatitude: Double, locationLongitude: Double, averageReviewScore: Double, instrumentsTeachable: [InstrumentsTeachable]) {
        self.teacherID = teacherID
        self.tagline = tagline
        self.bio = bio
        self.locationTitle = locationTitle
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        self.averageReviewScore = averageReviewScore
        self.instrumentsTeachable = instrumentsTeachable
        self.instrumentsRemovedIds = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.teacherID = try container.decode(Int.self, forKey: .teacherID)
        self.tagline = try container.decode(String.self, forKey: .tagline)
        self.bio = try container.decode(String.self, forKey: .bio)
        self.locationTitle = try container.decode(String.self, forKey: .locationTitle)
        self.locationLatitude = try container.decode(Double.self, forKey: .locationLatitude)
        self.locationLongitude = try container.decode(Double.self, forKey: .locationLongitude)
        self.averageReviewScore = try container.decode(Double.self, forKey: .averageReviewScore)
        self.instrumentsTeachable = try container.decode([InstrumentsTeachable].self, forKey: .instrumentsTeachable)
        self.instrumentsRemovedIds = []
    }

    enum CodingKeys: String, CodingKey {
        case teacherID = "teacher_id"
        case tagline, bio
        case locationTitle = "location_title"
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case averageReviewScore = "average_review_score"
        case instrumentsTeachable = "instruments_teachable"
        case instrumentsRemovedIds = "instruments_removed_ids"
    }
}

// MARK: - InstrumentsTeachable
/// Data model for instruments teachable by teacher
struct InstrumentsTeachable: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    var instrumentID, gradeID: Int
    var lessonCost: Int

    enum CodingKeys: String, CodingKey {
        case id
        case instrumentID = "instrument_id"
        case gradeID = "grade_id"
        case lessonCost = "lesson_cost"
    }
}
