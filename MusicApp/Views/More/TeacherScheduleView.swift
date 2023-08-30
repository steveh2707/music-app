//
//  TeacherPostScheduleView.swift
//  MusicApp
//
//  Created by Steve on 24/08/2023.
//

import SwiftUI

/// View showing teachers current schedule on a date view, with options to add or remove timeslots.
struct TeacherScheduleView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @StateObject private var vm = TeacherScheduleVM()
    @State var showNewTimeslotView = false
    @State var showEditTimeslotView = false
    
    // MARK: BODY
    var body: some View {
        VStack {
            DatePicker(
                "Start Date",
                selection: $vm.date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            Divider()
            if vm.selectedDaySlots.isEmpty {
                noSlotsAvailableOnDay
            } else {
                listOfSlotsAvailableOnDay
            }
        }
        .sheet(isPresented: $showNewTimeslotView) {
            TeacherScheduleModal(dateTimeStart: vm.date)
                .presentationDetents([.fraction(0.4)])
        }
        .sheet(isPresented: $showEditTimeslotView) {
            TeacherScheduleModal(availabilitySlot: vm.slot!)
                .presentationDetents([.fraction(0.4)])
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addButton
            }
        }
        .task {
            await vm.fetchSchedule(token: global.token)
        }
        .navigationBarTitle("Teaching Schedule", displayMode: .inline)
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    // Show no content view if no slots are available
    private var noSlotsAvailableOnDay: some View {
        VStack {
            Spacer()
            NoContentView(description: "Please add a timeslot using the + icon or switch to another day.")
            Spacer()
            Spacer()
        }
    }
    
    // Show a list of slots available on selected day. Selecting slot opens modal that allows editing/deleting.
    private var listOfSlotsAvailableOnDay: some View {
        List {
            Text("Scheduled Timeslots")
                .font(.title3)
                .fontWeight(.semibold)
                .listRowSeparator(.hidden)
            
            ForEach(vm.selectedDaySlots, id: \.self) { slot in
                Button {
                    vm.slot = slot
                    showEditTimeslotView.toggle()
                } label: {
                    Text((slot.parsedStartTime.asTime() ?? "" ) + " - " + (slot.parsedEndTime.asTime() ?? ""))
                }
            }
        }
        .listStyle(.plain)
    }
    
    // Button to add a new slot
    private var addButton: some View {
        Button {
            showNewTimeslotView.toggle()
        } label: {
            Image(systemName: "plus")
        }
        
    }
}


// MARK: PREVIEW
struct TeacherPostSchedule_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TeacherScheduleView()
                .environmentObject(dev.globalTeacherVM)
        }
    }
}
