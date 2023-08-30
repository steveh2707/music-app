//
//  ImagePickerVM.swift
//  MusicApp
//
//  Created by Steve on 14/07/2023.
//
import PhotosUI
import Foundation
import SwiftUI

/// View model for handling all business logic of ImagePicker View
class ImagePickerVM: ObservableObject {

    
    // MARK: PROPERTIES
    @Published var uiImage: UIImage?
    @Published var imageUrl: String?
    
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    @Published var signInResponse: SignInResponse? = nil
    
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to interface with API to upload new image
    /// - Parameter token: JWT token provided to user at login for authentication
    func uploadImage(token: String?) async {
        do {
            submissionState = .submitting
            
            let data = uiImage?.jpegData(compressionQuality: 0.1)
            
            let response = try await NetworkingManager.shared.request(.image(token: token, submissionData: data), type: ImageUploadResponse.self)
            
            self.imageUrl = response.profileImageUrl
            
            submissionState = .successful
        } catch {
            self.hasError = true
            self.submissionState = .unsuccessful
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}


struct ImageUploadResponse: Codable {
    var profileImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case profileImageUrl = "profile_image_url"
    }
}
