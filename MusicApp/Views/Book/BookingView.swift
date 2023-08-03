//
//  BookingView.swift
//  MusicApp
//
//  Created by Steve on 29/06/2023.
//

import SwiftUI

struct BookingView: View {
    
    @EnvironmentObject var global: Global
    @StateObject private var vm: BookingVM
    
    @State private var showMakeBookingView = false
    
    init(teacher: Teacher) {
        _vm = StateObject(wrappedValue: BookingVM(teacher: teacher))
    }
    
    
    var body: some View {
        
        ScrollView {
            datePicker
            
            dayHeadings
            
            if vm.lastBookingSlot == "00" {
                
                VStack {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                    Spacer()
                    Text(vm.teacher.fullName + " has no availability on any of the selected dates. Please try a new date.")
                        .multilineTextAlignment(.center)
                }
                
            } else {
                ZStack {
                    timelineBackground
                    
                    buttonOverlay
                }
            }
            Spacer()
            
        }
        .padding(.horizontal, 10)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                infoButton
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
        .sheet(isPresented: $showMakeBookingView) {
            MakeBookingView(vm: vm)
        }
        .animation(.linear, value: vm.teacherAvailability)
        
    }
    
    private var infoButton: some View {
        Button(action: {
            
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
//        .animation(.linear, value: vm.teacherAvailability)
        .padding(.bottom, 20)
    }
    
    private var timelineBackground: some View {
        VStack(spacing: 15) {
            
        
            ForEach(vm.filteredHours, id: \.self) { hour in
//                if hour > vm.firstBookingSlot {
                    HStack {
                        Text(hour+":00")
                            .font(Font.custom("Avenir", size: 9))
                            .frame(width: 28, height: 20, alignment: .center)
                        VStack {
                            Divider()
                        }
                    }
                    .offset(y:-17.5)
//                }
            }
        }
    }
    
    private var buttonOverlay: some View {
        HStack(alignment: .top) {
            if let teacherAvailability = vm.teacherAvailability?.availability {
                
                ForEach(teacherAvailability) { day in
                    VStack(spacing: 15) {
                        
                        ForEach(vm.filteredHours, id: \.self) { hour in
                            let matchingSlot = day.slots.first { hour >= $0.parsedStartTime.asHour()! && hour < $0.parsedEndTime.asHour()! }
                            let matchingBooking = day.bookings.first { hour >= $0.parsedStartTime.asHour()! && hour < $0.parsedEndTime.asHour()! }
                            
                            Button(action: {
                                print("\(day.parsedDate.asShortDateString()): \(hour)")
                                if matchingBooking == nil {
//                                    vm.selectedDate = day.date
//                                    vm.selectedTime = hour
                                    showMakeBookingView.toggle()
                                    let hoursOffset = Double(hour.replacingOccurrences(of: ":", with: "."))
                                    let minutesOffset = Int((hoursOffset ?? 0) * 60)
                                    vm.selectedDateTime = day.parsedDate.addOrSubtractMinutes(minutes: minutesOffset)

                                }
                                
                            }, label: {
                                Rectangle()
                                    .cornerRadius(15)
                            })
                            .tint(matchingBooking == nil ? Color.theme.accent : Color.theme.red)
                            .frame(height: 30)
                            .padding(.vertical, -5)
                            .padding(.horizontal, 5)
                            .disabled(matchingSlot == nil)
                        }
                        
                    }
                    .frame(width: 100)
                }
            }
        }
//        .animation(.easeOut, value: vm.teacherAvailability)
    }
    
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView(teacherId: 1)
//    }
//}
