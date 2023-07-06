//
//  TimelineView2.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import SwiftUI

struct TimelineView2: View {
    let hours: [String] = ["6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
//    let days = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
    let days = ["Mon", "Tues", "Wed"]
    
    @State var date = Date()
    
    var body: some View {
        VStack {
            DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                Text("Selected Date")
            }
            .datePickerStyle(.automatic)
            .frame(width: 250)
            .padding(.bottom)

            HStack(alignment: .top) {
                Image(systemName: "chevron.left")
                ForEach(days, id: \.self) { day in
                    VStack {
                        Text(day)
                        ForEach(hours, id: \.self) { hour in
                            ZStack {
                                Button {
                                    print("\(day): \(hour)")
                                } label: {
                                    Rectangle()
                                        .fill(Color.theme.accent)
                                        .cornerRadius(15)
                                        .frame(width: 100, height: 25)
                                }
                                .padding(.vertical, -2)
                                Text(hour)
                                    .font(.footnote)
                                    .foregroundColor(Color.theme.primaryTextInverse)
                            }
                        }
                    }
//                    .padding(.horizontal, -3)
                }
                Image(systemName: "chevron.right")
            }
            Spacer()
        }
        
    }
}

struct TimelineView2_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView2()
    }
}
