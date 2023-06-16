//
//  SearchResultsVM.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import Foundation

struct SearchCriteria: Codable {
    var userLatitude = 12
    var userLongitude = 12
    var instrumentId = 10
    var gradeRankId = 5
}

class searchResultsVM: ObservableObject {
    
    @Published var teachers: [Result] = []
    @Published var searchCriteria = SearchCriteria()
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
    
    @MainActor
    func seachForTeachers() async {
       
        do {
            state = .submitting
            
            print(searchCriteria)
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(searchCriteria)
            
            let decodedResponse = try await NetworkingManager.shared.request(.search(submissionData: data), type: SearchResults.self)
            self.teachers = decodedResponse.results
            
            state = .successful
        } catch {
            self.hasError = true
            self.state = .unsuccessful
            
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
            case is SignupValidator.NewUserValidatorError:
                self.error = .validation(error: error as! SignupValidator.NewUserValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
    }
    
}
