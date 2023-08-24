//
//  CachedImageManager.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import Foundation


final class CachedImageVM: ObservableObject {
    
    @Published private(set) var currentState: CurrentState?
    
    @MainActor
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
    
    
    enum CurrentState {
        case loading
        case failed(error: Error)
        case success(data: Data)
    }
    
}
