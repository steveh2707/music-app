//
//  NotificationCountView.swift
//  MusicApp
//
//  Created by Steve on 05/07/2023.
//

import SwiftUI

/// View displaying a badge for number of current notifications on a chat, handling increasing badge size for larger numbers
struct NotificationCountView : View {
    
    // MARK: PROPERTIES
    var value: Int
    @State var foreground: Color = .white
    @State var background: Color = .red
    private let size = 20.0
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Capsule()
                .fill(background)
                .frame(width: size * widthMultplier(), height: size)
            
            if hasTwoOrLessDigits() {
                Text("\(value)")
                    .foregroundColor(foreground)
                    .font(Font.caption)
            } else {
                Text("99+")
                    .foregroundColor(foreground)
                    .font(Font.caption)
                    .frame(width: size * widthMultplier(), height: size, alignment: .center)
            }
        }
        .opacity(value == 0 ? 0 : 1)
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    /// showing more than 99 might take too much space, rather display something like 99+
    /// - Returns: whether the value has 2 or less digits
    func hasTwoOrLessDigits() -> Bool {
        return value < 100
    }
    
    /// Width multiplier for badge depending on digits of number
    /// - Returns: width multiplier
    func widthMultplier() -> Double {
        if value < 10 {
            // one digit
            return 1.0
        } else if value < 100 {
            // two digits
            return 1.5
        } else {
            // too many digits, showing 99+
            return 2.0
        }
    }
}

// MARK: PREVIEW
struct NotificationCountView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCountView(value: 93)
    }
}
