//
//  SearchResultsRow.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import SwiftUI

/// Subview of SearchResults view for displaying each row of results
struct SearchResultsRowView: View {
    
    // MARK: PROPERTIES
    var teacher: TeacherResult
    
    // MARK: BODY
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                if let instrumentTeachable = teacher.instrumentTeachable {
                    
                    HStack(alignment: .center) {
                        InstrumentGradeView(sfSymbol: instrumentTeachable.sfSymbol, instrumentName: instrumentTeachable.instrumentName, gradeName: instrumentTeachable.gradeName, showGradeFrom: true, fixedLength: false)
                        
                        Spacer()
                        Text("£\(instrumentTeachable.lessonCost)")
                            .font(.title3)
                            .foregroundColor(Color.theme.accent)

                    }
                    .font(.callout)
                }
                
                HStack(alignment: .center) {
                    
                    UserImageView(imageURL: teacher.profileImageURL)
                        .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(teacher.fullName)
                                .lineLimit(1)
                                .font(.title2)
                            Spacer()
                            Image(systemName: "star.fill")
                                .font(.subheadline)
                            Text(String(teacher.averageReviewScore))
                                .font(.subheadline)
                                .padding(.leading, -5)
                        }
                        Text(teacher.tagline)
                            .opacity(0.8)
                            .lineLimit(2)
                            .font(.footnote)
                        if let distance = teacher.distanceInKM {
                            HStack {
                                Image(systemName: "map")
                                Text("\(distance.asNumberString()) km away")
                            }
                            .font(.footnote)
                            
                        }
                    }
                    .padding(.leading, 5)
                    Spacer(minLength: 0)
                }
                
                
                Text(teacher.bio)
                    .font(.footnote)
                    .lineLimit(3)
                    .opacity(0.8)
                
            }


        }
        .padding(.horizontal, -10)
        .foregroundColor(Color.theme.primaryText)
        
    }
    
}
