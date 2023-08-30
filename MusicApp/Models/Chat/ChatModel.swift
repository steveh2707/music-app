//
//  ChatModel.swift
//  MusicApp
//
//  Created by Steve on 21/06/2023.
//

import Foundation

// MARK: - ChatDetails
/// Data model for details of a chat conversation
struct ChatDetails: Codable, Equatable {
    let chatID: Int
    let createdTimestampUtc: String
    let teacherID, studentID: Int
    let student, teacher: UserSimple
    var messages: [Message]

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case createdTimestampUtc = "created_timestamp_utc"
        case teacherID = "teacher_id"
        case studentID = "student_id"
        case student, teacher, messages
    }
}

// MARK: - Message
/// Data model for each message within a chat conversation
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


// MARK: - NewMessage
/// Data model for a new message to be posted to the database
struct NewMessage: Codable {
    var message = ""
}
