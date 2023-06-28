//
//  SearchResultsRow.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import SwiftUI

struct SearchResultsRowView: View {
    
    var teacher: TeacherResult
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                HStack(alignment: .center) {
                    Image(systemName: teacher.instrumentSfSymbol)
                    Text(teacher.instrumentName)
                    Text(teacher.gradeTeachable)
                        .foregroundColor(Color.theme.primaryTextInverse)
                        .font(.footnote)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.theme.accent)
                        )
                    Spacer()
                    Image(systemName: "star.fill")
                        .font(.subheadline)
                    Text(String(teacher.averageReviewScore))
                        .font(.subheadline)
                        .padding(.leading, -5)
                }
                .font(.callout)
                
                HStack(alignment: .center) {
                    
                    UserImageView(imageURL: teacher.profileImageURL ?? "")
                        .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(teacher.firstName) \(teacher.lastName)")
                            .font(.title2)
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

//struct SearchResultsRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsRowView()
//    }
//}
