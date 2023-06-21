//
//  TimelineView.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import SwiftUI

struct TimelineView: View {
    let hours: [String] = ["7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
    var body: some View {
        ScrollView {
            HStack {
                
                ZStack {
                    VStack(spacing: 20) {
                        ForEach(hours, id: \.self) { hour in
                            ZStack{
                                HStack {
                                    Text(hour)
                                        .font(Font.custom("Avenir", size: 9))
                                        .frame(width: 28, height: 20, alignment: .center)
                                    VStack {
                                        Divider()
                                    }
                                }
                                Button {
                                    print("test")
                                } label: {
                                    Rectangle()
                                        .cornerRadius(15)
                                }
                                .offset(y:20)
                                .padding(.leading, 35)
                                .padding(.vertical, -8)
                            }
                            
                        }
                    }
                }

                Spacer()
            }
        }
        .padding(.top, 150)
        .padding(.bottom, 32)
        .padding(.horizontal, 16)
//        .background(backgroundPrimary)
        .ignoresSafeArea()
    }
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
