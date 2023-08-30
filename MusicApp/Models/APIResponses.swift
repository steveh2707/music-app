//
//  Networking.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import Foundation

// MARK: - ApiGenericResponse
/// Data model for API Generic response
struct ApiGenericResponse: Codable {
    let success: Bool
    let message: String
    let code: Int
}

// MARK: - UnreadResponse
/// Data model for unread messages API response
struct UnreadResponse: Codable {
    let unreadMessages: Int

    enum CodingKeys: String, CodingKey {
        case unreadMessages = "unread_messages"
    }
}

// MARK: - ReviewResults
/// Data model for review results API response
struct ReviewResults: Codable {
    let numResults, page, totalPages: Int
    let results: [Review]

    enum CodingKeys: String, CodingKey {
        case numResults = "num_results"
        case page
        case totalPages = "total_pages"
        case results
    }
}
