//
//  UserBookingsView.swift
//  MusicApp
//
//  Created by Steve on 07/07/2023.
//

import SwiftUI

/// View for users to see a list of their upcoming and past bookings
struct UserBookingsView: View {
    
    // MARK: PROPERTIES
    
    @EnvironmentObject var global: Global
    @StateObject var vm = UserBookingsVM()
    @State var hasAppeared = false
    @State var selectedFilter = BookingFilter.upcoming
    @State var showDetailSheet = false
    @State var reloadUserBookings = false
    
    let currentDate = Date()
    
    var filteredBookings: [UserBooking] {
        switch selectedFilter {
        case .all:
            return vm.bookings
        case .upcoming:
            return vm.bookings.filter { $0.parsedStartTime > currentDate}
        case .past:
            return vm.bookings.filter { $0.parsedStartTime < currentDate}
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
                                        
                                        // only allow students to cancel bookings up to 2 days before booking or allow teachers to cancel bookings right up to before booking starts
                                        if booking.parsedStartTime > currentDate.addOrSubtractDays(day: global.bookingCancellationMinDays) || (booking.teacherID == global.teacherDetails?.teacherID && booking.parsedStartTime > currentDate) {
                                            Button {
                                                vm.bookingDetail = booking
                                                showDetailSheet.toggle()
                                            } label: {
                                                Label("Cancel", systemImage: "calendar.badge.minus")
                                            }
                                            .tint(.red)
                                        } else if booking.parsedStartTime > currentDate {
                                            
                                        } else if booking.teacherID != global.teacherDetails?.teacherID {
                                            // allow students to review teachers after booking has happened
                                            Button {
                                                vm.bookingDetail = booking
                                                showDetailSheet.toggle()
                                            } label: {
                                                Label("Review", systemImage: "star.bubble.fill")
                                            }
                                            .tint(Color.theme.accent)
                                        }
                                    }
                                    
                                }
                                .saturation(booking.cancelled == 1 ? 0 : 1)
                                .disabled(booking.cancelled == 1)
                                .opacity(booking.cancelled == 1 ? 0.4 : 1)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookings")
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
        .onChange(of: reloadUserBookings, perform: { newValue in
            if newValue == true {
                Task {
                    await vm.getBookings(token: global.token)
                    reloadUserBookings = false
                }
            }
        })
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .alert("Booking Cancelled", isPresented: $vm.showBookingCancelledMessage) {
            Button("OK", role: .cancel) { }
        }
        .sheet(isPresented: $showDetailSheet) {
            BookingDetailView(bookingDetail: vm.bookingDetail!, reloadUserBookings: $reloadUserBookings)
                .presentationDetents([.fraction(0.7)])
        }
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    // button to refresh view using API request
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
    
    // selector to filter bookings on screen by upcoming, past or all
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
    
    // row in list for each booking
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
                        Text("\(booking.parsedStartTime.asTime() ?? "") - \(booking.parsedEndTime.asTime() ?? "")")
                            .font(.footnote)
                    }
                }
            }
            
            Spacer(minLength: 0)
            VStack {
                Text(booking.parsedStartTime.asdayOfMonthString() ?? "")
                Text(booking.parsedStartTime.asMonthOfYearNameShortString()?.uppercased() ?? "")
                Text(booking.parsedStartTime.asYearString() ?? "")
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
            .environmentObject(dev.globalStudentVM)
    }
}
