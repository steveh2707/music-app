//
//  Location.swift
//  MusicApp
//
//  Created by Steve on 30/08/2023.
//

import Foundation

// MARK: - Location
/// Data model for a location
struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    let latitude: Double
    let longitude: Double
}
