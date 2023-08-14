//
//  Sort.swift
//  MusicApp
//
//  Created by Steve on 14/08/2023.
//

import Foundation

enum SearchResultsSort: String, CaseIterable {
    
    case distanceAsc = "distance_in_km ASC"
    case distanceDesc = "distance_in_km DESC"
    case avReviewScoreAsc = "average_review_score ASC"
    case avReviewScoreDesc = "average_review_score DESC"
    case lessonCostAsc = "base_cost ASC"
    case lessonCostDesc = "base_cost DESC"
    
//    case distanceAsc = "distance.desc"
//    case distanceDesc = "distance.asc"
//    case avReviewScoreAsc = "average_review_score.asc"
//    case avReviewScoreDesc = "average_review_score.desc"
//    case lessonCostAsc = "lesson_cost.asc"
//    case lessonCostDesc = "lesson_cost.desc"
    
//    var sortString: String {
//        switch self {
//        case .distanceAsc:
//            return "distance.desc"
//        case .distanceDesc:
//            return "distance.asc"
//        case .avReviewScoreAsc:
//            return "average_review_score.asc"
//        case .avReviewScoreDesc:
//            return "average_review_score.desc"
//        case .lessonCostAsc:
//            return "lesson_cost.asc"
//        case .lessonCostDesc:
//            return "lesson_cost.desc"
//        }
//    }
    

    
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
        case .lessonCostAsc:
            return "Cost Asc"
        case .lessonCostDesc:
            return "Cost Desc"
        }
    }
    
    static var allCasesExclLocation: [SearchResultsSort] {
        return [
            .avReviewScoreAsc, .avReviewScoreDesc, .lessonCostAsc, .lessonCostDesc
        ]
    }
}
