//
//  HeadingView.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

/// View to show the logo of the app
struct HeadingView: View {
    var body: some View {
        HStack(spacing: 10) {
            Spacer(minLength: 0)
            Image("Treble")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
            Text("Treble")
                .font(.system(size: 30))
                .monospaced()
                .kerning(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/)
            Spacer(minLength: 0)
        }
        .foregroundColor(Color.theme.accent)
    }
}

struct HeadingView_Previews: PreviewProvider {
    static var previews: some View {
        HeadingView()
    }
}
