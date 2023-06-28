//
//  Networking.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import Foundation

struct ApiError: Codable {
    let success: Bool
    let message: String
    let code: Int
}
