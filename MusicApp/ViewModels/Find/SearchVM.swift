//
//  LocationFinderVM2.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import Foundation
import MapKit

class SearchVM: NSObject, ObservableObject {
    
    @Published var results: Array<AddressResult> = []
    @Published var searchableText = ""
    @Published var selectedLocation: SelectedLocation?
    @Published var instruments: [Instrument] = []
    @Published var grades: [Grade] = []
    @Published var searchCrtieria: SearchCriteria?
    
    @Published var viewState: ViewState?
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    @MainActor
    /// Makes an API call to get instrument and grades available and assigns them to local variables
    func getConfiguration() async {
        
        viewState = .fetching
        defer { viewState = .finished }
       
        do {
            let decodedResponse = try await NetworkingManager.shared.request(.configuration, type: Configuration.self)
            self.instruments = decodedResponse.instruments
            self.grades = decodedResponse.grades

        } catch {            
            if let errorCode = (error as NSError?)?.code, errorCode == NSURLErrorCancelled {
                return
            }
            
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    /// Finds the latitude and longitude of the location selected by the user and assigns to the local selectedLocation variable
    /// - Parameter address: The selected location
    func getPlace(from address: AddressResult) {
        let request = MKLocalSearch.Request()
        let title = address.title
        let subtitle = address.subtitle
        
        request.naturalLanguageQuery = subtitle.contains(title)
        ? subtitle : title + ", " + subtitle
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response, let coords = response.mapItems.first?.placemark.coordinate {
                self.selectedLocation = SelectedLocation(title: title, subtitle: subtitle, latitude: coords.latitude, longitude: coords.longitude)
            }
        }
    }
    
    
    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    /// Adds text to the local search completer to allow locations to be found
    /// - Parameter searchableText: This is the searchable text
    func searchAddress(_ searchableText: String) {
        guard searchableText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText
    }
    
}

extension SearchVM: MKLocalSearchCompleterDelegate {
    
    
    /// Adds title and subtitle of SeachCompleter results to an AddressResult Type then adds to the local results array.
    /// - Parameter completer: The MKLocalSearchCompleter
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            results = completer.results.map {
                AddressResult(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }
    
    
    /// Handle errors from the MKLocalSearchCompleter
    /// - Parameters:
    ///   - completer: The SearchCompleter
    ///   - error: Any error
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
