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
    let details: UserDetails
}

// MARK: - Details
struct UserDetails: Codable {
    let userID: Int
    var firstName, lastName, email, dob: String
    var registeredTimestamp, profileImageURL: String
    var password: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email, dob
        case registeredTimestamp = "registered_timestamp"
        case profileImageURL = "profile_image_url"
    }
    
    var formattedDob: Date {
        Date(mySqlDateTimeString: dob)
    }
}
