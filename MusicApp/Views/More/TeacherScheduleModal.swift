//
//  TeacherScheduleModal.swift
//  MusicApp
//
//  Created by Steve on 24/08/2023.
//

import SwiftUI

/// Modal view to allow teachers to add or edit a time slot on their schedule
struct TeacherScheduleModal: View {
    
    // MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var global: Global
    
    @ObservedObject var vm: TeacherScheduleVM
        
    var newTimeSlot: Bool { vm.slot.teacherAvailabilityID == 0 }
    
    
//    @State var availabilitySlot: AvailabilitySlot
//
//    var newTimeSlot: Bool
    
    
    // MARK: INITALIZATION
    
//    // initialize for a new time slot
//    init(dateTimeStart: Date) {
//        let roundedDateTimeStart = dateTimeStart.nearestHour()
//        let slot = AvailabilitySlot(teacherAvailabilityID: 0, startTime: roundedDateTimeStart, endTime: roundedDateTimeStart.addOrSubtractMinutes(minutes: 60))
//
//        _availabilitySlot = State(initialValue: slot)
//        newTimeSlot = true
//    }
//
//    // initialize for an existing time slot
//    init(availabilitySlot: AvailabilitySlot) {
//        _availabilitySlot = State(initialValue: availabilitySlot)
//        newTimeSlot = false
//    }
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(vm.slot.parsedStartTime.asMediumDateString())
                    }
                    DatePicker("Starts", selection: $vm.slot.parsedStartTime, displayedComponents: .hourAndMinute)
                    DatePicker("Ends", selection: $vm.slot.parsedEndTime, displayedComponents: .hourAndMinute)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !newTimeSlot {
                        deleteButton
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addOrSaveButton
                }
            }
            .navigationBarTitle(newTimeSlot ? "New Time Slot": "Edit Time Slot", displayMode: .inline)
        }
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    // Cancel button to close modal
    private var cancelButton: some View {
        Button("Cancel", role: .destructive) {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
//    // Add button to add new timeslot
//    private var addButton: some View {
//        Button("Add") {
//            Task {
//                await vm.addOrEditTimeSlot(token: global.token)
//            }
//        }
//    }
    
    // Add new or save edited timeslot
    private var addOrSaveButton: some View {
        Button(newTimeSlot ? "Add" : "Save") {
            Task {
                await vm.addOrEditTimeSlot(token: global.token)
                if vm.submissionState == .successful {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
//    // Save button to save changes to a timeslot
//    private var saveEditButton: some View {
//        Button("Save") {
//            //TODO: Edit timeslot
//        }
//    }
    
    // Delete a timeslot
    private var deleteButton: some View {
        Button("Delete") {
            Task {
                await vm.deleteTimeSlot(token: global.token)
                if vm.submissionState == .successful {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

}


// MARK: PREVIEW

//struct TeacherScheduleModal_Previews: PreviewProvider {
//    static var previews: some View {
//        TeacherScheduleModal(dateTimeStart: Date())
//    }
//}
