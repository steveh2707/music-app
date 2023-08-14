//
//  TempView.swift
//  MusicApp
//
//  Created by Steve on 04/08/2023.
//

import SwiftUI

struct TempView: View {
    var body: some View {
        Text("01:00")
            .fontWeight(.semibold)
            .foregroundColor(Color.theme.primaryText)
            .frame(width: 80, height: 30)
            .background(Color.theme.background)
            .cornerRadius(5)
            .padding(3) // Width of the border
            .background(Color.theme.accent) // Color of the border
            .cornerRadius(8) // Outer corner radius
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
