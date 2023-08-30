//
//  AllChatsModel.swift
//  MusicApp
//
//  Created by Steve on 23/06/2023.
//

import Foundation

// MARK: - AllChatsResponse
/// Data model for API response for all chats for a user
struct AllChatsResponse: Codable {
    let results: [ChatGeneral]
}

// MARK: - ChatGeneral
/// Data model for general chat information for all user's chats
struct ChatGeneral: Codable, Identifiable {
    let chatID: Int
    let createdTimestampUTC: String
    let teacherID, studentID: Int
    let student, teacher: UserSimple
    let mostRecentMessage: String?
    let unreadMessages: Int

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case createdTimestampUTC = "created_timestamp_utc"
        case teacherID = "teacher_id"
        case studentID = "student_id"
        case student, teacher
        case mostRecentMessage = "most_recent_message"
        case unreadMessages = "unread_messages"
    }
    
    var id: Int {chatID}
}
