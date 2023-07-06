//
//  TimelineView.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import SwiftUI

struct TimelineView: View {
    let hours: [String] = ["7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
    let days = ["Mon", "Tues", "Wed"]
    @State var date = Date()
    
    var body: some View {
            
        ScrollView {
                DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                    Text("Selected Date")
                }
                .datePickerStyle(.automatic)
                .frame(width: 250)
                .padding(.bottom)
                
                HStack {
                    Image(systemName: "chevron.left")
                    
                    VStack {
                        Text("Mon")
                        Text("11/01/23")
                    }
                    .frame(width: 100)
                    VStack {
                        Text("Tues")
                        Text("12/01/23")
                    }
                    .frame(width: 100)
                    VStack {
                        Text("Wed")
                        Text("13/01/23")
                    }
                    .frame(width: 100)
                    Image(systemName: "chevron.right")
                }
                .padding(.bottom, 20)

                
                ZStack {
                    
                    
                    VStack(spacing: 20) {
                        ForEach(hours, id: \.self) { hour in
                            
                            HStack {
                                Text(hour)
                                    .font(Font.custom("Avenir", size: 9))
                                    .frame(width: 28, height: 20, alignment: .center)
                                VStack {
                                    Divider()
                                }
                            }
                            .offset(y:-20)
                            
                        }
                    }
                    
                    HStack(alignment: .top) {
                        ForEach(days, id: \.self) { day in
                            VStack(spacing: 20) {
                                ForEach(hours, id: \.self) { hour in
                                    Button {
                                        print("test")
                                    } label: {
                                        Rectangle()
                                            .cornerRadius(15)
                                    }
                                    .frame(height: 30)
                                    .offset(y:0)
                                    .padding(.vertical, -5)
                                    .padding(.horizontal, 5)
                                }
                            }
                            .frame(width: 100)
                        }
                    }

                    
                }
                Spacer()
            }

        .padding(.horizontal, 10)
    }
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
