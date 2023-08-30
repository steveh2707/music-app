//
//  BookingView.swift
//  MusicApp
//
//  Created by Steve on 29/06/2023.
//

import SwiftUI

/// View showing teacher's schedule with selectable time slots.
struct BookingScheduleView: View {
    
    // MARK: PROPERTIES
    
    @EnvironmentObject var global: Global
    @StateObject private var vm: BookingVM
    
    // MARK: INITALIZATION
    init(teacher: Teacher) {
        // pass teacher to StateObject
        _vm = StateObject(wrappedValue: BookingVM(teacher: teacher))
    }
    
    // MARK: BODY
    var body: some View {
        ScrollView {
            VStack {
                datePicker
                
                dayHeadings
                
                if vm.teacherAvailability?.slots == [] {
                    NoContentView(description: vm.teacher.fullName + " has no availability on any of the selected dates. Please try a new date.")
                } else {
                    bookingButtons
                }
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                infoButton
            }
            ToolbarItem(placement: .principal) {
                Text(vm.teacher.fullName)
            }
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .task {
            await vm.getTeacherAvailability(token: global.token)
        }
        .onChange(of: vm.searchDate) { _ in
            Task {
                await vm.getTeacherAvailability(token: global.token)
            }
        }
        .sheet(isPresented: $vm.showMakeBookingView) {
            MakeBookingView(vm: vm)
        }
        .sheet(isPresented: $vm.showInfoPage) {
            BookingInfoScreen()
                    .presentationDetents([.fraction(0.4)])
        }
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    // Button to toggle info modal screen.
    private var infoButton: some View {
        Button(action: {
            vm.showInfoPage.toggle()
        }, label: {
            Image(systemName: "info")
                .font(.headline)
        })
    }
    
    // Let user select a date in the future for booking.
    private var datePicker: some View {
        DatePicker(selection: $vm.searchDate, in: Date.now..., displayedComponents: .date) {
            Text("Selected Date")
        }
        .datePickerStyle(.automatic)
        .frame(width: 250)
        .padding(.bottom)
    }
    
    // Headings for each of the days to be displayed with buttons to navigate to next/previous days.
    private var dayHeadings: some View {
        HStack {
            
            Button {
                vm.searchDate = vm.searchDate.addOrSubtractDays(day: -1)
            } label: {
                Image(systemName: "chevron.left")
            }
            
            ForEach(vm.searchedDates, id: \.self) { day in
                VStack {
                    Text(day.asDayOfWeekString() ?? "")
                        .font(.subheadline)
                    Text(day.asShortDateString())
                        .font(.caption)
                }
                .frame(width: 100)
            }
            
            Button {
                vm.searchDate = vm.searchDate.addOrSubtractDays(day: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
            
        }
        .padding(.bottom, 10)
    }

    // Loop through each day included in the search
    private var bookingButtons: some View {
        HStack(alignment: .top) {
            if let teacherAvailability = vm.teacherAvailability {

                ForEach(vm.searchedDates, id: \.self) { day in
                    
                    VStack(spacing: 15) {
                        ForEach(teacherAvailability.slots) { slot in
                            
                            ForEach(vm.getHoursBetweenTwoDates(
                                startTime: Date(mySqlDateTimeString: slot.startTime),
                                endTime: Date(mySqlDateTimeString: slot.endTime)
                            ), id: \.self) { hour in
                                
                                if Calendar.current.isDate(hour, inSameDayAs: day) {
                                    let matchingBooking = teacherAvailability.bookings.first {
                                        hour >= $0.parsedStartTime
                                        && hour < $0.parsedEndTime
                                    }
                                    
                                    Button(action: {
                                        if matchingBooking == nil {
                                            vm.showMakeBookingView.toggle()
                                            vm.selectedDateTime = hour
                                        }
                                    }, label: {
                                        BookingSelectorButton(hour: hour, selectable: matchingBooking == nil)
                                    })
                                }
                            }
                            

                            
                        }
                    }
                    .frame(width: 100)
                    
                }
            }
        }
    }
    
}
