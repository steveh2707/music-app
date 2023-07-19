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
    @State var showLocationSearch = false
//    @State private var selectedInstrument = ["Guitar"]
//    @State private var selectedGrade = ["Grade 4"]
//
//
//    let instruments = [
//        Instrument(instrumentID: 1, name: "Piano", sfSymbol: "pianokeys", imageUrl: ""),
//        Instrument(instrumentID: 2, name: "Guitar", sfSymbol: "guitar", imageUrl: "")
//    ]
//    let grades = [
//        Grade(gradeID: 1, name: "Grade 4", rank: 4),
//        Grade(gradeID: 2, name: "Grade 5", rank: 5)
//    ]
    
//    let instruments = ["Guitar", "Piano", "Voice"]
//    let grades = ["Grade 4", "Grade 5", "Grade 6"]
    
    let updatingExistingTeacher: Bool
    
    init (teacherDetails: TeacherDetails? = nil, updatingExistingTeacher: Bool = true) {
        if let teacherDetails {
            _vm = StateObject(wrappedValue: EditTeacherDetailsVM(teacher: teacherDetails))
        } else {
            _vm = StateObject(wrappedValue: EditTeacherDetailsVM(teacher: TeacherDetails(teacherID: 0, tagline: "", bio: "", locationLatitude: 0.0, locationLongitude: 0.0, averageReviewScore: 0.0, instrumentsTeachable: [])))
        }
        self.updatingExistingTeacher = updatingExistingTeacher
    }
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    if updatingExistingTeacher {
                        Text("Tagline")
                            .font(.headline)
                    }
                    TextField("Tagline", text: $vm.teacher.tagline)
                }
                VStack(alignment: .leading) {
                    if updatingExistingTeacher {
                        Text("Bio")
                            .font(.headline)
                    }
                    TextField("Bio", text: $vm.teacher.bio,  axis: .vertical)
                        .lineLimit(5...)
                }

                locationSelector
            }
            
            Section {
                ForEach(Array(vm.teacher.instrumentsTeachable.enumerated()), id: \.offset) { index, element in

                        VStack {
                            Picker("Instrument", selection: $vm.teacher.instrumentsTeachable[index].instrumentID) {
                                ForEach(global.instruments, id: \.self) { instrument in
                                    Text(instrument.name)
                                        .tag(instrument.instrumentID)
                                }
                            }
                            .pickerStyle(.menu)
                            Picker("Max Grade Teachable", selection: $vm.teacher.instrumentsTeachable[index].gradeID) {
                                ForEach(global.grades, id: \.self) { grade in
                                    Text(grade.name)
                                        .tag(grade.gradeID)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        .swipeActions {
                            if vm.teacher.instrumentsTeachable.count > 1 {
                                Button {
                                    vm.teacher.instrumentsTeachable.remove(at: index)
                                } label: {
                                    Label("Delete", systemImage: "minus.circle")
                                }
                                .tint(.red)
                            }
                        }
                }
                HStack {
                    Spacer()
                    Button {
                        vm.teacher.instrumentsTeachable.append(InstrumentsTeachable(id: 0, instrumentID: 1, gradeID: 1))
                        
                    } label: {
                        Image(systemName: "plus.app.fill")
                            .font(.title)
                    }
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
        .task {
            if global.instruments.isEmpty {
                await global.getConfiguration()
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
                if let location = vm.selectedLocation {
                    Text(location.title)
                        .opacity(0.5)
                } else {
                    Image(systemName: "chevron.right")
                }
            }
        }
        .foregroundColor(Color.theme.primaryText)
    }
}

struct BecomeTeacherView_Previews: PreviewProvider {
    static var previews: some View {
        EditTeacherDetails()
    }
}




