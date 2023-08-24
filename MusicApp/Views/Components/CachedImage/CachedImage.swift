//
//  CachedImage.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import SwiftUI

struct CachedImage<Content: View>: View {
    
    @StateObject private var vm = CachedImageVM()
    let url: String
    @ViewBuilder let content: (AsyncImagePhase) -> Content
    
    enum CachedImageError: Error {
        case invalidData
    }
    
        var body: some View {
        
        ZStack {
            
            switch vm.currentState {
            case .loading:
                content(.empty)
            case .success(let data):
                if let image = UIImage(data: data) {
                    content(.success(Image(uiImage: image)))
                } else {
                    content(.failure(CachedImageError.invalidData))
                }
            case .failed(let error):
                content(.failure(error))
            default:
                content(.empty)
            }
        }
        .task {
            await vm.load(url)
        }
        
        
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedImage(url: "https://www.rimmersmusic.co.uk/images/yamaha-gb1k-grand-piano-polished-ebony-p25773-139507_image.jpg") { _ in
            EmptyView()
        }
    }
}
