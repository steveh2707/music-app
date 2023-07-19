//
//  LocationFinderVM2.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import Foundation
import MapKit

class SearchVM: NSObject, ObservableObject {
    
//    @Published var results: Array<AddressResult> = []
//    @Published var searchableText = ""
    @Published var selectedLocation: SelectedLocation?
    @Published var searchCrtieria: SearchCriteria?
//    @Published var instruments: [Instrument] = []
//    @Published var grades: [Grade] = []
//    
//    @Published var viewState: ViewState?
//    @Published var submissionState: SubmissionState?
//    @Published var hasError = false
//    @Published var error: NetworkingManager.NetworkingError?
    
//    @MainActor
//    /// Makes an API call to get instrument and grades available and assigns them to local variables
//    func getConfiguration() async {
//
//        viewState = .fetching
//        defer { viewState = .finished }
//
//        do {
//            let decodedResponse = try await NetworkingManager.shared.request(.configuration, type: Configuration.self)
//            self.instruments = decodedResponse.instruments
//            self.grades = decodedResponse.grades
//
//        } catch {
//            if let errorCode = (error as NSError?)?.code, errorCode == NSURLErrorCancelled {
//                return
//            }
//
//            self.hasError = true
//            if let networkingError = error as? NetworkingManager.NetworkingError {
//                self.error = networkingError
//            } else {
//                self.error = .custom(error: error)
//            }
//        }
//    }
    

}

