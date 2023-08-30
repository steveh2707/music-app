//
//  InstrumentGradeView.swift
//  MusicApp
//
//  Created by Steve on 10/07/2023.
//

import SwiftUI

/// View for displaying instrument name, grade and lesson cost consistently.
struct InstrumentGradeView: View {
    
    // MARK: PROPERTIES
    let sfSymbol: String
    let instrumentName: String
    let gradeName: String
    var lessonCost: Int? = nil
    var showGradeFrom: Bool = false
    var fixedLength: Bool = false

    // MARK: BODY
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: sfSymbol)
                    .frame(width: 30)
                Text(instrumentName)
                    .frame(width: fixedLength ? 85 : nil , alignment: .leading)
                    .lineLimit(1)
                HStack(spacing: 5) {
                    if showGradeFrom {
                        Text("Grade 1")
                        Image(systemName: "arrowshape.forward")
                    }
                    Text(gradeName)
                    
                }
                .foregroundColor(Color.theme.primaryTextInverse)
                .font(.footnote)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(Color.theme.accent)
                )
                if let lessonCost {
                    Spacer()
                    Text("£\(lessonCost)")
                        .foregroundColor(Color.theme.accent)
                    Spacer()
                }
            }
        }
        
    }
}

// MARK: PREVIEW
struct InstrumentGradeView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentGradeView(sfSymbol: "pianokeys", instrumentName: "Saxaphone", gradeName: "Grade 4", lessonCost: 10)
    }
}
