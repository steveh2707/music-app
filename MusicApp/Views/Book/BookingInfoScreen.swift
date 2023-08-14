//
//  BookingInfoScreen.swift
//  MusicApp
//
//  Created by Steve on 04/08/2023.
//

import SwiftUI

struct BookingInfoScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    BookingSelectorButton(hour:  Date(mySqlDateTimeString: "2023-09-09T12:00:00.000Z"), selectable: true)
                        .padding(.horizontal)
                    Text("Time slot is available")
                    Spacer()
                }
                HStack {
                    BookingSelectorButton(hour:  Date(mySqlDateTimeString: "2023-09-09T12:00:00.0000Z"), selectable: false)
                        .padding(.horizontal)
                    Text("Time has been booked by another student")
                    Spacer()
                }
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Info")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
            }
        }
    }
}

struct BookingInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        BookingInfoScreen()
    }
}
