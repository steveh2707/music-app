//
//  TeacherVM.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation
import MapKit


class TeacherVM: ObservableObject {
    
    @Published var teacherDetails: TeacherDetails? = nil
    @Published var error: NetworkingManager.NetworkingError?
    @Published var hasError = false
    @Published var isLoading = false
    @Published var mapRegion = MKCoordinateRegion()
    @Published var locations = [Location]()
    
    @MainActor
    func getTeacherDetails(teacherId: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.teacherDetails = try await NetworkingManager.shared.request(.teacher(id: teacherId), type: TeacherDetails.self)
            
            if let teacherDetails {
                self.mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: teacherDetails.locationLatitude, longitude: teacherDetails.locationLongitude), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
                let newLocation = Location(id: UUID(), latitude: teacherDetails.locationLatitude, longitude: teacherDetails.locationLongitude)
                locations.append(newLocation)
            }
            
        } catch {
            
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
}
