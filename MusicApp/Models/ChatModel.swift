//
//  ChatModel.swift
//  MusicApp
//
//  Created by Steve on 21/06/2023.
//

import Foundation

// MARK: - Welcome
struct Chat: Codable, Equatable {
    let chatID: Int
    let createdTimestampUtc: String
    let teacherID, teacherUserID: Int
    let teacherFirstName, teacherLastName, lastLoginTimestamp: String
    let profileImageURL: String
    var messages: [Message]

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case createdTimestampUtc = "created_timestamp_utc"
        case teacherID = "teacher_id"
        case teacherUserID = "teacher_user_id"
        case teacherFirstName = "teacher_first_name"
        case teacherLastName = "teacher_last_name"
        case lastLoginTimestamp = "last_login_timestamp"
        case profileImageURL = "profile_image_url"
        case messages
    }
}

// MARK: - Message
struct Message: Codable, Hashable {
    let chatMessageID: Int
    let message, createdTimestamp: String
    let senderID: Int

    enum CodingKeys: String, CodingKey {
        case chatMessageID = "chat_message_id"
        case message
        case createdTimestamp = "created_timestamp"
        case senderID = "sender_id"
    }
}
