//
//  SearchModels.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import Foundation

// MARK: - AddressResult
/// Data model for an address result
struct AddressResult: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
}

// MARK: - SelectedLocation
/// Data model for a selected location
struct SelectedLocation: Equatable {
    var title: String
    var latitude: Double
    var longitude: Double
}

// MARK: - Configuration
/// Data model for instruments and grades available throughout app
struct Configuration: Codable {
    let instruments: [Instrument]
    let grades: [Grade]
}

// MARK: - Grade
/// Data model for a music grade
struct Grade: Codable, Identifiable, Hashable {
    let gradeID: Int
    let name: String
    let rank: Int

    enum CodingKeys: String, CodingKey {
        case gradeID = "grade_id"
        case name, rank
    }
    
    var id: Int {gradeID}
}

// MARK: - Instrument
/// Data model for an instrument
struct Instrument: Codable, Identifiable, Hashable {
    let instrumentID: Int
    let name, sfSymbol: String
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case instrumentID = "instrument_id"
        case name
        case sfSymbol = "sf_symbol"
        case imageUrl = "image_url"
    }
    
    var id: Int {instrumentID}
}
