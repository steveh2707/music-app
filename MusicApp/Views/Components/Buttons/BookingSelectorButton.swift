//
//  BookingSelectorButton.swift
//  MusicApp
//
//  Created by Steve on 04/08/2023.
//

import SwiftUI

/// Booking selector button label
struct BookingSelectorButton: View {
    
    // MARK: PROPERTIES
    var hour: Date
    var selectable: Bool
    var selectableTrueColor = Color.theme.accent
    var selectableFalseColor = Color.theme.red
    
    // MARK: BODY
    var body: some View {
        Text(hour.asTime() ?? "")
            .fontWeight(.semibold)
            .foregroundColor(Color.theme.primaryText)
            .frame(width: 80, height: 30)
            .background(Color.theme.background)
            .cornerRadius(5)
            .padding(3) // Width of the border
            .background(selectable ? Color.theme.accent : Color.theme.red) // Color of the border
            .cornerRadius(8) // Outer corner radius
    }
}

// MARK: PREVIEW
struct BookingSelectorButton_Previews: PreviewProvider {
    static var previews: some View {
        BookingSelectorButton(hour: Date(), selectable: true)
    }
}
