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
//    @Published var selectedInstrument: Instrument? = nil
    @Published var grades: [Grade] = []
//    @Published var selectedGrade: Grade? = nil
    @Published var searchCrtieria: SearchCriteria?
    
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    @MainActor
    func getConfiguration() async {
       
        do {
            state = .submitting

            let decodedResponse = try await NetworkingManager.shared.request(.configuration, type: Configuration.self)
            self.instruments = decodedResponse.instruments
            self.grades = decodedResponse.grades
            
            state = .successful
        } catch {
            self.hasError = true
            self.state = .unsuccessful
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    

    
    
    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    func searchAddress(_ searchableText: String) {
        guard searchableText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText
    }
    
    @MainActor
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
}


extension SearchVM: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            results = completer.results.map {
                AddressResult(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
