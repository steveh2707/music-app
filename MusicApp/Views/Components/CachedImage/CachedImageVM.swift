//
//  CachedImageManager.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import Foundation

/// View model for handling all business logic of CachedImage View
final class CachedImageVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published private(set) var currentState: CurrentState?
    
    // MARK: FUNCTIONS
    
    @MainActor
    /// Function to either load an image from the cache, if available, or load from URL and save to cache
    /// - Parameters:
    ///   - imgUrl: URL of image location
    ///   - cache: image cache where cached images are stored
    func load(_ imgUrl: String, cache: ImageCache = .shared) async {
        
        self.currentState = .loading
        
        // check if image is in cache and load if so
        if let imageData = cache.object(forKey: imgUrl as NSString) {
            self.currentState = .success(data: imageData)
            return
        }
        
        // load image from url
        do {
            guard let url = URL(string: imgUrl) else {
                throw NetworkingManager.NetworkingError.invalidUrl
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            self.currentState = .success(data: data)
            cache.set(object: data as NSData, forKey: imgUrl as NSString)
        } catch {
            self.currentState = .failed(error: error)
        }
    }
    
    
    /// Enum for the current state of the view model
    enum CurrentState {
        case loading
        case failed(error: Error)
        case success(data: Data)
    }
    
}
