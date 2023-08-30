//
//  MapView.swift
//  MusicApp
//
//  Created by Steve on 31/07/2023.
//

import SwiftUI
import MapKit

/// View for displaying a map view based on provided latitude and longitude
struct MapView: View {
    
    // MARK: PROPERTIES
    @Binding var latitude: Double
    @Binding var longitude: Double
    var spanDelta: Double = 0.03
    
    private var mapRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
    }
    private var locations: [Location] {
        [Location(id: UUID(), latitude: latitude, longitude: longitude)]
    }
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Map(coordinateRegion: .constant(mapRegion), interactionModes: [.zoom], annotationItems: locations) { location in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
    }
}

// MARK: PREVIEW
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(latitude: .constant(51.509865), longitude: .constant(-0.118092))
    }
}



