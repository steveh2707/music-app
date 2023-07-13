//
//  UserBookingsView.swift
//  MusicApp
//
//  Created by Steve on 07/07/2023.
//

import SwiftUI

struct UserBookingsView: View {
    
    // MARK: PROPERTIES
    
    @EnvironmentObject var global: Global
    @StateObject var vm = UserBookingsVM()
    @State var hasAppeared = false
    @State var selectedFilter = BookingFilter.upcoming
    @State var showDeleteSheet = false

    
    var filteredBookings: [UserBooking] {
        switch selectedFilter {
        case .all:
            return vm.bookings
        case .upcoming:
            return vm.bookings.filter { $0.formattedDate > Date()}
        case .past:
            return vm.bookings.filter { $0.formattedDate < Date()}
        }
    }
    
    
    // MARK: BODY
    var body: some View {
        NavigationStack {
            
            ZStack {
                VStack {
            
                    List {
                        Section {
                            filterSelector
                            
                            ForEach(filteredBookings) { booking in
                                
                                ZStack {
                                    NavigationLink {
                                        TeacherView(teacherId: booking.teacherID)
                                    } label: {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    .swipeActions {
                                        Button {
                                            vm.bookingToBeDeleted = booking
                                            showDeleteSheet.toggle()
                                        } label: {
                                            Label("Cancel", systemImage: "calendar.badge.minus")
                                        }
                                        .tint(.red)
                                    }
                                    bookingRowView(booking)
                                }
                                .saturation(booking.cancelled == 1 ? 0 : 1)
                                .disabled(booking.cancelled == 1)
                                .opacity(booking.cancelled == 1 ? 0.4 : 1)
                            }
                            .onDelete { booking in
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    refresh
                }
            }
        }
        .task {
            await vm.getBookings(token: global.token)
        }
        .overlay {
            if vm.viewState == .fetching {
                ProgressView()
            }
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .alert("Booking Cancelled", isPresented: $vm.showBookingCancelledMessage) {
            Button("OK", role: .cancel) { }
        }
        .sheet(isPresented: $showDeleteSheet) {
            CancelUserBookingView(vm: vm)
                    .presentationDetents([.fraction(0.6)])

        }
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    var refresh: some View {
        Button {
            Task {
                await vm.getBookings(token: global.token)
            }
        } label: {
            Image(systemName: "arrow.clockwise")
        }
        .disabled(vm.viewState == .fetching)
    }
    
    private var filterSelector: some View {
        Picker("Test", selection: $selectedFilter) {
            ForEach(BookingFilter.allCases, id: \.self) { item in
                Text(item.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .padding(.bottom, 5)
    }
    
    private func bookingRowView(_ booking: UserBooking) -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 10) {
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
                    .frame(width: 75, height: 75)
                    .cornerRadius(20)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(booking.teacherFirstName) \(booking.teacherLastName)")
                            .font(.title3)
                            .lineLimit(1)
                        if let instrumentName = booking.instrumentName, let grade = booking.gradeName {
                            HStack(spacing: 5) {
                                Text(instrumentName)
                                Text("-")
                                Text(grade)
                            }
                            .font(.subheadline)
                            .lineLimit(1)
                        }
                        Text("\(booking.startTime) - \(booking.endTime)")
                            .font(.footnote)
                    }
                }
            }
            
            Spacer(minLength: 0)
            VStack {
                Text(booking.formattedDate.asdayOfMonthString() ?? "")
                Text(booking.formattedDate.asMonthOfYearNameShortString()?.uppercased() ?? "")
                Text(booking.formattedDate.asYearString() ?? "")
                
            }
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            
        }
    }
    
    
}


// MARK: PREVIEW
struct UserBookingsView_Previews: PreviewProvider {
    static var previews: some View {
        
        UserBookingsView()
            .environmentObject(dev.globalVM)
    }
}
