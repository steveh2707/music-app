//
//  UserBookingsView.swift
//  MusicApp
//
//  Created by Steve on 07/07/2023.
//

import SwiftUI

struct UserBookingsView: View {
    
//    let token =
    
    @EnvironmentObject var global: Global
    @StateObject var vm = UserBookingsVM()
    @State var hasAppeared = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.bookings) { booking in
//                    Text(booking.date)

                    
                    HStack {
                        CachedImage(url: booking.instrumentImageURL ?? "") { phase in
                            switch phase {
                            case .empty:
                                Color
                                    .theme.accent
                                    .overlay {
                                        ProgressView()
                                    }
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Color
                                    .theme.accent
                                    .opacity(0.75)
                                    .overlay {
                                        Image(systemName: "music.note")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20)
                                            .foregroundColor(Color.theme.primaryTextInverse)
                                            .opacity(0.5)
                                    }
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(20)
                        VStack(alignment: .leading) {
                            Text("\(booking.teacherFirstName) \(booking.teacherLastName)")
                            Text(booking.instrumentName ?? "")
                            Text(booking.gradeName ?? "")
                            Text("\(booking.startTime) - \(booking.endTime)")
                        }
                        
                        
                        Spacer()
                        VStack {
                            Text(booking.formattedDate.asdayOfMonthString() ?? "")
                            Text(booking.formattedDate.asMonthOfYearNameShortString() ?? "")
                            Text(booking.formattedDate.asYearString() ?? "")
                            
                        }
                    }
                    
                }
                
            }
            .navigationTitle("Bookings")
        }
        
        .task {
            await vm.getBookings(token: global.token)
        }
        .overlay {
            if vm.state == .submitting {
                ProgressView()
            }
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
    }
}

struct UserBookingsView_Previews: PreviewProvider {
    static var previews: some View {
        
        UserBookingsView()
            .environmentObject(dev.globalVM)
    }
}
