//
//  ImageRetriever.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import Foundation

struct ImageRetriever {
    
    func fetch(_ imgUrl: String) async throws -> Data {
        guard let url = URL(string: imgUrl) else {
            throw NetworkingManager.NetworkingError.invalidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
}
