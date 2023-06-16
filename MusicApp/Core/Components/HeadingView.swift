//
//  HeadingView.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

struct HeadingView: View {
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            Image(systemName: "music.note.list")
                .font(.largeTitle)
            Text("Treble")
                .font(.system(size: 30))
                .monospaced()
                .kerning(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/)
            Spacer(minLength: 0)
        }
        .foregroundColor(Color.theme.accent)
        .padding(.top)
    }
}

struct HeadingView_Previews: PreviewProvider {
    static var previews: some View {
        HeadingView()
    }
}
