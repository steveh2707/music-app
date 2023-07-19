//
//  SearchModels.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import Foundation

struct AddressResult: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
}

struct SelectedLocation: Equatable {
    let title: String
    let subtitle: String
    let latitude: Double
    let longitude: Double
}

// MARK: - Configuration
struct Configuration: Codable {
    let instruments: [Instrument]
    let grades: [Grade]
}

// MARK: - Grade
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
