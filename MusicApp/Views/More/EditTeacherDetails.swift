//
//  BecomeTeacherView.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import SwiftUI

struct EditTeacherDetails: View {

    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @StateObject var vm: EditTeacherDetailsVM
    @State private var showLocationSearch = false
    @State private var showSaveChangesAlert = false
    @Binding var teacherDetailsUpdated: Int
    
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
    }
    
    
    // MARK: VARIABLES
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
    
    private var logoutButton: some View {
        Button {
            global.logout()
        } label: {
            Image(systemName: "rectangle.portrait.and.arrow.right")
        }
    }
    
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
                    vm.teacherDetails.instrumentsTeachable.append(InstrumentsTeachable(id: 0, instrumentID: 1, gradeID: 1))
                    
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

// MARK: PREVIEW
//struct BecomeTeacherView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTeacherDetails()
//    }
//}




