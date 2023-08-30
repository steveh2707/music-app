//
//  StaticJSONMapper.swift
//  MusicApp
//
//  Created by Steve on 26/06/2023.
//

import Foundation

/// Function to map local JSON files to Data Model
struct StaticJSONMapper {
    
    /// Decode JSON file to Data Model
    /// - Parameters:
    ///   - file: file name
    ///   - type: Data model type to decode to
    /// - Returns: Data model of selected type
    static func decode<T: Decodable>(file: String, type: T.Type) throws -> T {
        
        guard !file.isEmpty,
              let path = Bundle.main.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            throw MappingError.failedToGetContents
        }
        
        let decoder = JSONDecoder()

        return try decoder.decode(T.self, from: data)
    }
}

extension StaticJSONMapper {
    /// Custom error for mapping JSON
    enum MappingError: Error {
        case failedToGetContents
    }
}
