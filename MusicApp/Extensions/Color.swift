//
//  Color.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let backgroundSecondary = Color("BackgroundSecondaryColor")
    let primaryText = Color("PrimaryTextColor")
    let primaryTextInverse = Color("PrimaryTextInverseColor")
    let secondaryText = Color("SecondaryTextColor")
    let linkText = Color("LinkColor")
    let red = Color("Red")
}
