//
//  BookingView.swift
//  MusicApp
//
//  Created by Steve on 29/06/2023.
//

import SwiftUI

struct BookingScheduleView: View {
    
    @EnvironmentObject var global: Global
    @StateObject private var vm: BookingVM
    
    init(teacher: Teacher) {
        _vm = StateObject(wrappedValue: BookingVM(teacher: teacher))
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                datePicker
                
                dayHeadings
                
                if vm.teacherAvailability?.slots == [] {
                    noAvailability
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
//        .animation(.easeIn , value: vm.teacherAvailability)
        
    }
    
    private var infoButton: some View {
        Button(action: {
            vm.showInfoPage.toggle()
        }, label: {
            Image(systemName: "info")
                .font(.headline)
        })
    }
    
    private var datePicker: some View {
        DatePicker(selection: $vm.searchDate, in: Date.now..., displayedComponents: .date) {
            Text("Selected Date")
        }
        .datePickerStyle(.automatic)
        .frame(width: 250)
        .padding(.bottom)
    }
    
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
    
    private var noAvailability: some View {
        VStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.title)
            Spacer()
            Text(vm.teacher.fullName + " has no availability on any of the selected dates. Please try a new date.")
                .multilineTextAlignment(.center)
        }
    }
    
    private var bookingButtons: some View {
        HStack(alignment: .top) {
            if let teacherAvailability = vm.teacherAvailability {

                ForEach(vm.searchedDates, id: \.self) { day in
                    
                    VStack(spacing: 15) {
                        ForEach(0..<24, id: \.self) {
                            let hour = Calendar.current.date(byAdding: .hour, value: $0, to: day)!
                            
                            let matchingSlot = teacherAvailability.slots.first {
                                hour >= $0.parsedStartTime
                                && hour < $0.parsedEndTime
                            }
                            
                            if matchingSlot != nil {
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
                    .frame(width: 100)
                }
            }
        }
    }
    
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView(teacherId: 1)
//    }
//}
