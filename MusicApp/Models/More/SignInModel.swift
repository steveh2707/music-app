//
//  LoginModel.swift
//  MusicApp
//
//  Created by Steve on 22/06/2023.
//

import Foundation

struct Credentials: Codable {
    var email: String = ""
    var password: String = ""
}

//struct SignInResponse: Codable {
//    let token: String
//
//    enum CodingKeys: String, CodingKey {
//        case token
//    }
//}

// MARK: - Welcome
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

// MARK: - Details
struct UserDetails: Codable, Equatable {
    let userID: Int
    var firstName, lastName, email, dob: String
    var registeredTimestamp, profileImageURL: String
    var formattedDob: Date

//    init(userID: Int, firstName: String, lastName: String, email: String, dob: String, registeredTimestamp: String, profileImageURL: String, formattedDate: Date? = nil) {
//        self.userID = userID
//        self.firstName = firstName
//        self.lastName = lastName
//        self.email = email
//        self.dob = dob
//        self.registeredTimestamp = registeredTimestamp
//        self.profileImageURL = profileImageURL
//        self.formattedDob =  Date(mySqlDateTimeString: dob)
//    }
    
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
    }
    

}


// MARK: - TeacherDetails
struct TeacherDetails: Codable, Equatable {
    let teacherID: Int
    var tagline, bio: String
    var locationLatitude, locationLongitude, averageReviewScore: Double
    var instrumentsTeachable: [InstrumentsTeachable]

    enum CodingKeys: String, CodingKey {
        case teacherID = "teacher_id"
        case tagline, bio
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case averageReviewScore = "average_review_score"
        case instrumentsTeachable = "instruments_teachable"
    }
}

// MARK: - InstrumentsTeachable
struct InstrumentsTeachable: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    var instrumentID, gradeID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case instrumentID = "instrument_id"
        case gradeID = "grade_id"
    }
}
