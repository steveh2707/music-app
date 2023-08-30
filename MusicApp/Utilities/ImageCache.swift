//
//  ImageCache.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import Foundation

/// Class for setting up the image cache to be used by the CachedImage view
class ImageCache {
    
    typealias CacheType = NSCache<NSString, NSData>
    
    // share instance of image cache
    static let shared = ImageCache()
    
    private init() {}
    
    // set variables for cache
    private lazy var cache: CacheType = {
        let cache = CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024  // 50 MB
        return cache
    }()
    
    /// Get object from cache
    /// - Parameter key: key to identify object
    /// - Returns: Data for selected object
    func object(forKey key: NSString) -> Data? {
        cache.object(forKey: key) as? Data
    }
    
    /// Add new object to cache
    /// - Parameters:
    ///   - object: object to be stored in cache
    ///   - key: key for object
    func set(object: NSData, forKey key: NSString) {
        cache.setObject(object, forKey: key)
    }
}
