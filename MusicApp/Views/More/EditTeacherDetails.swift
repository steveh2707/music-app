//
//  BecomeTeacherView.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import SwiftUI

/// View to allow teachers to access and update their teacher details.
struct EditTeacherDetails: View {

    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @StateObject var vm: EditTeacherDetailsVM
    @State private var showLocationSearch = false
    @State private var showSaveChangesAlert = false
    @Binding var teacherDetailsUpdated: Int
    
    // MARK: INITALIZATION
    init (teacherDetails: TeacherDetails, newTeacher: Bool = false, teacherDetailsUpdated: Binding<Int>) {
        _vm = StateObject(wrappedValue: EditTeacherDetailsVM(teacher: teacherDetails, newTeacher: newTeacher))
        _teacherDetailsUpdated = teacherDetailsUpdated
    }
    
    // MARK: BODY
    var body: some View {
        Form {
            teacherDetailsSection
            
            instrumentsTeachableSection
        }
        .sheet(isPresented: $showLocationSearch) {
            LocationFinderView(selectedLocation: $vm.selectedLocation)
        }
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                editableToggleButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                logoutButton
            }
        }
        .task {
            if global.instruments.isEmpty {
                await global.getConfiguration()
            }
        }
        .onChange(of: vm.selectedLocation, perform: { newLocation in
            vm.teacherDetails.locationTitle = newLocation.title
            vm.teacherDetails.locationLatitude = newLocation.latitude
            vm.teacherDetails.locationLongitude = newLocation.longitude
        })
        .onChange(of: vm.teacherDetailsStart, perform: { newTeacherDetails in
            global.teacherDetails = newTeacherDetails
            teacherDetailsUpdated += 1
        })
        .alert("Do you want to save changes?", isPresented: $showSaveChangesAlert) {
            Button("Save", action: {
                 Task {
                     await vm.updateTeacherDetails(token: global.token)
                 }
             })
             Button("Discard", role: .destructive, action: {
                 vm.teacherDetails = vm.teacherDetailsStart
                 vm.editable.toggle()
             })
         }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
    }
    
    
    // MARK: VARIABLES
    
    // button to toggle whether details are editable or not
    private var editableToggleButton: some View {
        Button {
            if vm.teacherDetailsStart == vm.teacherDetails {
                vm.editable.toggle()
            } else {
                showSaveChangesAlert.toggle()
            }
        } label: {
            if vm.editable {
                Image(systemName: "lock.open.fill")
            } else {
                Image(systemName: "lock.fill")
            }
        }
    }
    
    // button to log user out by calling global function
    private var logoutButton: some View {
        Button {
            global.logout()
        } label: {
            Image(systemName: "rectangle.portrait.and.arrow.right")
        }
    }
    
    // teacher's details which can be edited when editable variable set to true
    private var teacherDetailsSection: some View {
        Section {
            VStack(alignment: .leading) {
                if vm.teacherDetailsStart.tagline != "" {
                    Text("Tagline")
                        .font(.headline)
                }
                TextField("Tagline", text: $vm.teacherDetails.tagline)
                    .lineLimit(2...)
                    .foregroundColor(vm.editable ? Color.theme.accent : Color.theme.primaryText)
                    .disabled(!vm.editable)
            }
            VStack(alignment: .leading) {
                if vm.teacherDetailsStart.bio != "" {
                    Text("Bio")
                        .font(.headline)
                }
                TextField("Bio", text: $vm.teacherDetails.bio,  axis: .vertical)
                    .lineLimit(5...)
                    .foregroundColor(vm.editable ? Color.theme.accent : Color.theme.primaryText)
                    .disabled(!vm.editable)
            }

            locationSelector
            
            if !(vm.selectedLocation.latitude == 0 && vm.selectedLocation.longitude == 0) {
                MapView(latitude: $vm.selectedLocation.latitude, longitude: $vm.selectedLocation.longitude)
            }
        }
    }
    
    // show location search view in a modal screen
    private var locationSelector: some View {
        Button {
            showLocationSearch = true
        } label: {
            HStack {
                Text("Location")
                Spacer()
                Text(vm.selectedLocation.title != "" ? vm.selectedLocation.title : "Select")
                    .opacity(0.7)
            }
        }
        .foregroundColor(vm.editable ? Color.theme.accent : Color.theme.primaryText)
        .disabled(!vm.editable)
    }
    
    // list of instruments taught by teacher, to what grade, with lesson price. Also allows new instruments to be added or old instruments to be removed.
    private var instrumentsTeachableSection: some View {
        Section {
            ForEach(Array(vm.teacherDetails.instrumentsTeachable.enumerated()), id: \.offset) { index, element in

                    VStack {
                        Picker("Instrument", selection: $vm.teacherDetails.instrumentsTeachable[index].instrumentID) {
                            ForEach(global.instruments, id: \.self) { instrument in
                                Text(instrument.name)
                                    .tag(instrument.instrumentID)
                            }
                        }
                        .pickerStyle(.menu)
                        .disabled(!vm.editable)
                        
                        Picker("Max Grade Teachable", selection: $vm.teacherDetails.instrumentsTeachable[index].gradeID) {
                            ForEach(global.grades, id: \.self) { grade in
                                Text(grade.name)
                                    .tag(grade.gradeID)
                            }
                        }
                        .pickerStyle(.menu)
                        .disabled(!vm.editable)
                        
                        Picker("Lesson Cost (£)", selection: $vm.teacherDetails.instrumentsTeachable[index].lessonCost) {
                            ForEach(1...99, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.menu)
                        .disabled(!vm.editable)
                    }
                    .swipeActions {
                        if vm.teacherDetails.instrumentsTeachable.count > 1 {
                            Button {
                                vm.teacherDetails.instrumentsRemovedIds.append(vm.teacherDetails.instrumentsTeachable[index].id)
                                vm.teacherDetails.instrumentsTeachable.remove(at: index)
                            } label: {
                                Label("Delete", systemImage: "minus.circle")
                            }
                            .tint(.red)
                            .disabled(!vm.editable)
                        }
                    }
            }
            HStack {
                Spacer()
                Button {
                    vm.teacherDetails.instrumentsTeachable.append(InstrumentsTeachable(id: 0, instrumentID: 1, gradeID: 1, lessonCost: 20))
                } label: {
                    Image(systemName: "plus.app.fill")
                        .font(.title)
                }
                .disabled(!vm.editable)
                Spacer()
            }
        } header: {
            Text("Instruments Teachable")
        }
    }
}



