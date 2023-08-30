//
//  TeacherImageView.swift
//  MusicApp
//
//  Created by Steve on 19/06/2023.
//

import SwiftUI

/// View to display the users image handling the success and failure states for accessing the image from the CachedImage View
struct UserImageView: View {
    
    // MARK: PROPERTIES
    var imageURL: String
    
    // MARK: BODY
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
                        .clipShape(Circle())
                case .failure:
                    Color
                        .theme.accent
                        .opacity(0.75)
                        .overlay {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
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

// MARK: PREVIEW
struct UserImageView_Previews: PreviewProvider {
    static var previews: some View {
        UserImageView(imageURL: "https://images.unsplash.com/photo-1540569014015-19a7be504e3a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=735&q=80")
            .frame(width: 200, height: 200)
        UserImageView(imageURL: "")
            .frame(width: 100, height: 200)
    }
}
