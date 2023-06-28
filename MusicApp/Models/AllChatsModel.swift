//
//  AllChatsModel.swift
//  MusicApp
//
//  Created by Steve on 23/06/2023.
//

import Foundation

// MARK: - Welcome
struct AllChatsResponse: Codable {
    let results: [ChatResult]
}

// MARK: - Result
struct ChatResult: Codable, Identifiable {
    let chatID: Int
    let createdTimestampUTC: String
    let teacherID: Int
    let firstName, lastName: String
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case createdTimestampUTC = "created_timestamp_utc"
        case teacherID = "teacher_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImageURL = "profile_image_url"
    }
    
    var id: Int {chatID}
}
