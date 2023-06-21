//
//  Double.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import Foundation

extension Double {
    
    /// Converts a Double into a string representation with 0 decimal places
    /// ```
    ///Convert 1.23456 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.0f", self)
    }
}
