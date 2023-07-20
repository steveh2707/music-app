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
    @State var showDetailSheet = false

    
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
                                    Button {
                                        vm.bookingDetail = booking
                                        showDetailSheet.toggle()
                                    } label: {
                                        bookingRowView(booking)
                                            .foregroundColor(Color.theme.primaryText)
                                    }
                                    
                                    .swipeActions {
                                        Button {
                                            vm.bookingDetail = booking
                                            showDetailSheet.toggle()
                                        } label: {
                                            Label("Cancel", systemImage: "calendar.badge.minus")
                                        }
                                        .tint(.red)
                                    }
                                    
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
        .sheet(isPresented: $showDetailSheet) {
            BookingDetailView(vm: vm)
                    .presentationDetents([.fraction(0.7)])

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
                    CachedImage(url: booking.instrument.imageURL) { phase in
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
                        HStack(spacing: 5) {
                            var userIsTeacher: Bool { booking.teacherID == global.teacherDetails?.teacherID }
                            
                            if userIsTeacher {
                                Image(systemName: "studentdesk")
                            }
                            Text(userIsTeacher ? booking.student.fullName : booking.teacher.fullName)
                                .font(.title3)
                        }
                            .lineLimit(1)
                        
                        HStack(spacing: 5) {
                            Text(booking.instrument.name)
                            Text("-")
                            Text(booking.grade.name)
                        }
                        .font(.subheadline)
                        .lineLimit(1)
                        
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
