//
//  LocationFinderVM.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import Foundation
import MapKit

class LocationFinderVM: NSObject, ObservableObject {
    @Published var searchableText = ""
    @Published var results: Array<AddressResult> = []
    @Published var selectedLocation: SelectedLocation?
    
    
    @MainActor
    /// Finds the latitude and longitude of the location selected by the user and assigns to the local selectedLocation variable
    /// - Parameter address: The selected location
    func getPlace(from address: AddressResult) {
        let request = MKLocalSearch.Request()
        let title = address.title
        let subtitle = address.subtitle
        
        request.naturalLanguageQuery = subtitle.contains(title) ? subtitle : title + ", " + subtitle
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response, let coords = response.mapItems.first?.placemark.coordinate {
                self.selectedLocation = SelectedLocation(title: title, latitude: coords.latitude, longitude: coords.longitude)
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


extension LocationFinderVM: MKLocalSearchCompleterDelegate {
    
    
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
