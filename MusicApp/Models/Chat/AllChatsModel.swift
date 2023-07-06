//
//  AllChatsModel.swift
//  MusicApp
//
//  Created by Steve on 23/06/2023.
//

import Foundation

// MARK: - Welcome
struct AllChatsResponse: Codable {
    let results: [ChatGeneral]
}

// MARK: - Result
struct ChatGeneral: Codable, Identifiable {
    let chatID: Int
    let createdTimestampUTC: String
    let teacherID: Int
    let firstName, lastName: String
    let profileImageURL: String?
    let mostRecentMessage: String?
    let unreadMessages: Int

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case createdTimestampUTC = "created_timestamp_utc"
        case teacherID = "teacher_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImageURL = "profile_image_url"
        case mostRecentMessage = "most_recent_message"
        case unreadMessages = "unread_messages"
    }
    
    var id: Int {chatID}
}
