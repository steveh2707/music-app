//
//  ProfileView.swift
//  MusicApp
//
//  Created by Steve on 11/07/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var global: Global
    @StateObject private var vm: ProfileViewVM
    
    @State private var showImagePickerView = false
    @State private var showLocationFinderView = false
    @State private var showSaveChangesAlert = false
    @State private var editable = false

    init(userDetails: UserDetails, teacherDetails: TeacherDetails? = nil) {
//        let emptyTeacher = TeacherDetails(teacherID: 0, tagline: "", bio: "", locationLatitude: 0.0, locationLongitude: 0.0, averageReviewScore: 0.0)
        
//        if let teacherDetails {
//            _vm = StateObject(wrappedValue: ProfileViewVM(userDetails: userDetails, teacherDetails: teacherDetails))
//        } else {
//            _vm = StateObject(wrappedValue: ProfileViewVM(userDetails: userDetails))
//        }

        _vm = StateObject(wrappedValue: ProfileViewVM(userDetails: userDetails, teacherDetails: teacherDetails))
    }
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    HStack {
                        Text("Profile Image")
                        Spacer()
                        Button {
                            showImagePickerView.toggle()
                        } label: {
                            UserImageView(imageURL: global.userDetails?.profileImageURL ?? "")
                                .frame(width: 50, height: 50)
                        }
                    }
                    
                    HStack {
                        Text("First Name")
                        TextField("", text: $vm.userDetails.firstName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(editable ? Color.theme.accent : Color.theme.primaryText)
                            .disabled(!editable)
                    }
                    
                    HStack {
                        Text("Last Name")
                        TextField("", text: $vm.userDetails.lastName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(editable ? Color.theme.accent : Color.theme.primaryText)
                            .disabled(!editable)
                    }
                    
                    HStack {
                        Text("Email")
                        TextField("", text: $vm.userDetails.email)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(editable ? Color.theme.accent : Color.theme.primaryText)
                            .disabled(!editable)
                    }
                    
                    HStack {
                        Text("Date of Birth")
                        Spacer()
                        DatePicker(selection: $vm.userDetails.formattedDob, in: ...Date.now, displayedComponents: .date) {}
                            .padding(.trailing, -10)
                            .labelsHidden()
                            .datePickerStyle(.automatic)
                            .colorInvert()
                            .colorMultiply(editable ? Color.theme.accent : Color.theme.primaryText)
                            .disabled(!editable)
                    }
                    
                    HStack {
                        Text("Password")
                        Spacer()
                        Button {
//                            updateField = true
//                            updateFieldTitle = "Password"
                        } label: {
                            Text("Update")
                        }
                        .disabled(!editable)
                    }
                } header: {
                    Text("User Details")
                }
                
                if let  teacherDetails = vm.teacherDetails {

                    Section {
                        
                        NavigationLink("Update Teacher Details") {
                            EditTeacherDetails(teacherDetails: teacherDetails)
                        }
                        
//                        TextField("Tagline", text: $vm.teacherDetails.tagline, axis: .vertical)
//                            .lineLimit(1...)
//                            .foregroundColor(editable ? Color.theme.accent : Color.theme.primaryText)
//                            .disabled(!editable)
//
//                        TextField("Bio", text: $vm.teacherDetails.bio, axis: .vertical)
//                            .lineLimit(5...)
//                            .foregroundColor(editable ? Color.theme.accent : Color.theme.primaryText)
//                            .disabled(!editable)
//
//                        HStack {
//                            Text("Location")
//                            Spacer()
//                            Button {
//                                showLocationFinderView = true
//                            } label: {
//                                Text(vm.selectedLocation?.title == "" ? "Update" : vm.selectedLocation?.title ?? "Update")
//                            }
//                            .disabled(!editable)
//
//                        }
                    } header: {
                        Text("Teacher Details")
                    }
                }
                
            }
            .navigationTitle("Profile")
//            .alert("Do you want to save changes?", isPresented: $showSaveChangesAlert) {
//                Button("Save Changes", action: {
//                    // TODO: post changes
//                })
//                Button("Delete Changes", role: .destructive, action: {
//                    vm.userDetails = vm.userDetailsStart
//                    vm.teacherDetails = vm.teacherDetailsStart
//                    vm.selectedLocation = nil
//                    editable = false
//                })
//            }
            .sheet(isPresented: $showImagePickerView) {
                ImagePicker(currentImageUrl: global.userDetails?.profileImageURL)
                    .presentationDetents([.medium])
            }
//            .sheet(isPresented: $showLocationFinderView) {
//                LocationFinderView(selectedLocation: $vm.selectedLocation)
//            }
//            .onChange(of: vm.selectedLocation, perform: { newValue in
//                if let newValue {
//                    vm.teacherDetails.locationLatitude = newValue.latitude
//                    vm.teacherDetails.locationLongitude = newValue.longitude
//                }
//
//            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if vm.userDetailsStart == vm.userDetails
//                            && vm.teacherDetailsStart == vm.teacherDetails
                        {
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
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        let userDetails = UserDetails(userID: 1, firstName: "Stephen", lastName: "Hanna", email: "shanna@gmail.com", dob: "1978-07-02T23:00:00.000Z", registeredTimestamp: "2022-10-03T16:52:49.000Z", profileImageURL: "https://musicapp-file-storage.s3.eu-west-1.amazonaws.com/DEC5451C.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAQZSA5A6ZTDLDHQIK%2F20230718%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20230718T100246Z&X-Amz-Expires=3600&X-Amz-Signature=2f48e91ec2eaaf0484c338958492d6b1a512037a7a121ba6dc8a4a5e79c1931e&X-Amz-SignedHeaders=host&x-id=GetObject")
//        ProfileView(userDetails: userDetails)
//            .environmentObject(dev.globalVM)
//    }
//}

//func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
//    Binding(
//        get: { lhs.wrappedValue ?? rhs },
//        set: { lhs.wrappedValue = $0 }
//    )
//}
