//
//  ReviewsView.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import SwiftUI

/// View to show a single review as a row to make up a list
struct ReviewRowView: View {
    
    // MARK: PROPERTIES
    var review: Review
    var showDivider = false
    
    // MARK: BODY
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .center) {
                
                UserImageView(imageURL: review.profileImageUrl)
                    .frame(width: 70, height: 70)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(review.fullName)
                            .lineLimit(1)
                        Spacer()
                        RatingView(rating: .constant(review.numStars), centered: false, spacing: 0)
                    }
                    
                    Text(Date(mySqlDateTimeString: review.createdTimestamp).asMediumDateString())
                        .font(.callout)
                        .foregroundColor(Color("SecondaryTextColor"))
                    
                    InstrumentGradeView(sfSymbol: review.sfSymbol, instrumentName: review.instrumentName, gradeName: review.gradeName)
                        .padding(.top, -5)
                }
                Spacer()
            }
            Text(review.details)
            if showDivider {
                Divider()
                    .padding(.bottom, 5)
            }
        }
    }
}

