//
//  TeacherImageView.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import SwiftUI

struct UserImageView: View {
    
    var imageURL: String
    
    var body: some View {
        
        CachedImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                Color
                    .theme.accent
                    .overlay {
                        ProgressView()
                    }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Color
                    .theme.accent
                    .opacity(0.75)
                    .overlay {
                        Image(systemName: "music.note")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(Color.theme.primaryTextInverse)
                            .opacity(0.5)
                    }
            @unknown default:
                EmptyView()
            }
        }
        .clipShape(Circle())
    }
}

struct UserImageView_Previews: PreviewProvider {
    static var previews: some View {
        UserImageView(imageURL: "https://images.unsplash.com/photo-1540569014015-19a7be504e3a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=735&q=80")
            .frame(width: 200, height: 200)
    }
}
