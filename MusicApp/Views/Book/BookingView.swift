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

    let hours: [String] = ["07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]
    
//    let teacher: Teacher
    
    
    var body: some View {
        
        ScrollView {
            datePicker
            
            dayHeadings
            
            ZStack {
                timelineBackground
                
                buttonOverlay
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
                    Text(day.dayOfWeek() ?? "")
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
        .animation(.easeInOut, value: vm.teacherAvailability)
        .padding(.bottom, 20)
    }
    
    private var timelineBackground: some View {
        VStack(spacing: 15) {
            ForEach(hours, id: \.self) { hour in
                
                HStack {
                    Text(hour)
                        .font(Font.custom("Avenir", size: 9))
                        .frame(width: 28, height: 20, alignment: .center)
                    VStack {
                        Divider()
                    }
                }
                .offset(y:-17.5)
                
            }
        }
    }
    
    private var buttonOverlay: some View {
        HStack(alignment: .top) {
            if let teacherAvailability = vm.teacherAvailability?.availability {
                
                ForEach(teacherAvailability) { day in
                    VStack(spacing: 15) {
                        
                        ForEach(hours, id: \.self) { hour in
                            let matchingSlot = day.slots.first { hour >= $0.startTime && hour < $0.endTime }
                            let matchingBooking = day.bookings.first { hour >= $0.startTime && hour < $0.endTime }
                            
                            Button(action: {
                                print("\(day.date): \(hour)")
                                if matchingBooking == nil {
                                    vm.selectedDate = day.date
                                    vm.selectedTime = hour
                                    showMakeBookingView.toggle()
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
        .animation(.easeOut, value: vm.teacherAvailability)
    }
    
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView(teacherId: 1)
//    }
//}
