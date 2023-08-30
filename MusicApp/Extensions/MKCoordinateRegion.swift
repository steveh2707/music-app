//
//  MKCoordinateRegion.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    
    
    /// Sets default region for a Map View to be London
    /// - Returns: Coordinate Region for London
    static func defaultRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
    
}
