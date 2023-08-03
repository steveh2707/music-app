//
//  RatingView.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import SwiftUI

struct RatingView: View {
    
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    var centered = true
    var spacing:CGFloat = 10
    
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
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
