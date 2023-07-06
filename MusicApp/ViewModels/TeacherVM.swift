//
//  TeacherVM.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import Foundation
import MapKit


class TeacherVM: ObservableObject {
    
    @Published var teacher: Teacher? = nil
    @Published var mapRegion = MKCoordinateRegion.defaultRegion()
    @Published var locations = [Location]()
    
    @Published var state: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    
    @MainActor
    func getTeacherDetails(teacherId: Int) async {
        
        do {
            state = .submitting
            
            self.teacher = try await networkingManager.request(session: .shared,
                                                                      .teacher(id: teacherId),
                                                                      type: Teacher.self)
            
            if let teacher {
                self.mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: teacher.locationLatitude, longitude: teacher.locationLongitude), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
                let newLocation = Location(id: UUID(), latitude: teacher.locationLatitude, longitude: teacher.locationLongitude)
                locations.append(newLocation)
            }
            
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
    
}
