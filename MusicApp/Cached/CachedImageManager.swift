//
//  CachedImageManager.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import Foundation


final class CachedImageManager: ObservableObject {
    
    @Published private(set) var currentState: CurrentState?
    
    private let imageRetriever = ImageRetriever()
    
    @MainActor
    func load(_ imgUrl: String, cache: ImageCache = .shared) async {
        
        self.currentState = .loading
        
        if let imageData = cache.object(forKey: imgUrl as NSString) {
            self.currentState = .success(data: imageData)
            
            #if DEBUG
            print("📱 Fetching image from the cache: \(imgUrl)")
            #endif
            return
        }
        
        do {
            
            let data = try await imageRetriever.fetch(imgUrl)
            
            self.currentState = .success(data: data)
            cache.set(object: data as NSData, forKey: imgUrl as NSString)

            #if DEBUG
            print("📱 Caching image: \(imgUrl)")
            #endif
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
