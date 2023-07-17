//
//  Data.swift
//  MusicApp
//
//  Created by Steve on 14/07/2023.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
