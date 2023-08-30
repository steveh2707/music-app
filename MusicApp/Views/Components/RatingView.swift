//
//  RatingView.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import SwiftUI

/// View to allow users to select a star rating for a teacher when making a review.
struct RatingView: View {
    
    // MARK: PROPERTIES
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    var centered = true
    var spacing: CGFloat = 10
    
    // MARK: BODY
    var body: some View {
        HStack(spacing: spacing) {
            if centered {
                Spacer()
            }
            if !label.isEmpty {
                Text(label)
                Spacer()
            }            
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
            if centered {
                Spacer()
            }
        }

    }
    
    /// Decide whether star should be onImage or offImage based on rating
    /// - Parameter number: number of star
    /// - Returns: either off or on image for star rating
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

// MARK: PREVIEW
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
