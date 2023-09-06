//
//  Sort.swift
//  MusicApp
//
//  Created by Steve on 14/08/2023.
//

import Foundation

/// Enum for the different sort options for teacher search results
enum SearchResultsSort: String, CaseIterable {
    
    case distanceAsc = "distance_in_km ASC"
    case distanceDesc = "distance_in_km DESC"
    case avReviewScoreAsc = "average_review_score ASC"
    case avReviewScoreDesc = "average_review_score DESC"
    
    var sortName: String {
        switch self {
        case .distanceAsc:
            return "Distance Asc"
        case .distanceDesc:
            return "Distance Desc"
        case .avReviewScoreAsc:
            return "Rating Asc"
        case .avReviewScoreDesc:
            return "Rating Desc"
        }
    }
    
    static var allCasesExclLocation: [SearchResultsSort] {
        return [
            .avReviewScoreAsc, .avReviewScoreDesc
        ]
    }
}
