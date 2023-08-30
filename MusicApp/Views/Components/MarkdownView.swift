//
//  MarkdownView.swift
//  MusicApp
//
//  Created by Steve on 29/08/2023.
//

import SwiftUI

/// View to display a Markdown file
struct MarkdownView: View {
    
    // MARK: PROPERTIES
    let title: String
    let fileName: String
    var text: LocalizedStringKey {
        let filepath = Bundle.main.url(forResource: fileName, withExtension: "md")!
         return LocalizedStringKey(try! String(contentsOf: filepath))
    }
    
    // MARK: BODY
    var body: some View {
        ScrollView {
            Text(text)
                .padding()
        }
        .navigationTitle(title)
    }
}


// MARK: PREVIEW
struct TOSView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MarkdownView(title: "Terms of Service", fileName: "TOS")
        }
    }
}
