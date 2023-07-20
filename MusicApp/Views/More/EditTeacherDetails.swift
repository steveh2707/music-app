//
//  BecomeTeacherView.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import SwiftUI

struct EditTeacherDetails: View {

    @EnvironmentObject var global: Global
    @StateObject var vm: EditTeacherDetailsVM
    @State private var showLocationSearch = false
    @State private var showSaveChangesAlert = false
    @State private var editable: Bool
    
    let updatingExistingTeacher: Bool
    
    init (teacherDetails: TeacherDetails? = nil, updatingExistingTeacher: Bool = true) {
        if let teacherDetails {
            _vm = StateObject(wrappedValue: EditTeacherDetailsVM(teacher: teacherDetails))
        } else {
            _vm = StateObject(wrappedValue: EditTeacherDetailsVM(teacher: TeacherDetails(teacherID: 0, tagline: "", bio: "", locationLatitude: 0.0, locationLongitude: 0.0, averageReviewScore: 0.0, instrumentsTeachable: [])))
        }
        self.updatingExistingTeacher = updatingExistingTeacher
        if !updatingExistingTeacher {
            self.editable = true
        } else {
            self.editable = false
        }
    }
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    if updatingExistingTeacher {
                        Text("Tagline")
                            .font(.headline)
                    }
                    TextField("Tagline", text: $vm.teacherDetails.tagline)
                        .lineLimit(2...)
                        .foregroundColor(editable ? Color.theme.accent : Color.theme.primaryText)
                        .disabled(!editable)
                }
                VStack(alignment: .leading) {
                    if updatingExistingTeacher {
                        Text("Bio")
                            .font(.headline)
                    }
                    TextField("Bio", text: $vm.teacherDetails.bio,  axis: .vertical)
                        .lineLimit(5...)
                        .foregroundColor(editable ? Color.theme.accent : Color.theme.primaryText)
                        .disabled(!editable)
                }

                locationSelector
            }
            
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
                            .disabled(!editable)
                            
                            Picker("Max Grade Teachable", selection: $vm.teacherDetails.instrumentsTeachable[index].gradeID) {
                                ForEach(global.grades, id: \.self) { grade in
                                    Text(grade.name)
                                        .tag(grade.gradeID)
                                }
                            }
                            .pickerStyle(.menu)
                            .disabled(!editable)
                        }
                        .swipeActions {
                            if vm.teacherDetails.instrumentsTeachable.count > 1 {
                                Button {
                                    vm.teacherDetails.instrumentsTeachable.remove(at: index)
                                } label: {
                                    Label("Delete", systemImage: "minus.circle")
                                }
                                .tint(.red)
                                .disabled(!editable)
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
                    .disabled(!editable)
                    Spacer()
                }
            } header: {
                Text("Instruments Teachable")
            }



        }
        .sheet(isPresented: $showLocationSearch) {
            LocationFinderView(selectedLocation: $vm.selectedLocation)
        }
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if vm.teacherDetailsStart == vm.teacherDetails {
                        editable.toggle()
                    } else {
                        showSaveChangesAlert.toggle()
                    }
                } label: {
                    if editable {
                        Image(systemName: "lock.open.fill")
                    } else {
                        Image(systemName: "lock.fill")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    global.logout()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
            
        }
        .task {
            if global.instruments.isEmpty {
                await global.getConfiguration()
            }
        }
        //TODO: Add save changes alert here and to ProfileView
    }
    
    private var locationSelector: some View {
        Button {
            showLocationSearch = true
        } label: {
            HStack {
                Text("Location")
                Spacer()
                if let location = vm.selectedLocation {
                    Text(location.title)
                        .opacity(0.5)
                } else {
                    Image(systemName: "chevron.right")
                }
            }
        }
        .foregroundColor(Color.theme.primaryText)
        .disabled(!editable)
    }
}

struct BecomeTeacherView_Previews: PreviewProvider {
    static var previews: some View {
        EditTeacherDetails()
    }
}




