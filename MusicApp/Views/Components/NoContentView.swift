//
//  NoContentView.swift
//  MusicApp
//
//  Created by Steve on 14/08/2023.
//

import SwiftUI

struct NoContentView: View {
    
    var description: String?
    var imageName = "magnifyingglass"
    var opacity = 0.6
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 50))
                .fontWeight(.bold)
                .opacity(opacity)
                .padding(.bottom)
            Text("No Results")
                .font(.title3)
                .fontWeight(.bold)
            if let description {
                Text(description)
                    .opacity(opacity)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

struct NoContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoContentView(description: "Check spelling or try a new search.")
    }
}
