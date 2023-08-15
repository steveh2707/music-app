//
//  ProfileView.swift
//  MusicApp
//
//  Created by Steve on 11/07/2023.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @StateObject private var vm: ProfileViewVM
    
    @State private var showImagePickerView = false
    @State private var showLocationFinderView = false
    @State private var showSaveChangesAlert = false

    // State variables to update to force view update
    @State var teacherDetailsUpdated = 0
    @State var profileImageUpdated = 0

    init(userDetails: UserDetails, teacherDetails: TeacherDetails? = nil) {
        _vm = StateObject(wrappedValue: ProfileViewVM(userDetails: userDetails, teacherDetails: teacherDetails))
    }
    
    // MARK: BODY
    var body: some View {
        NavigationStack {
            List {
                userDetailsSection
                
                if let teacherDetails = vm.teacherDetails {
                    Section {
                        NavigationLink("Teacher Details") {
                            EditTeacherDetails(teacherDetails: teacherDetails, teacherDetailsUpdated: $teacherDetailsUpdated)
                        }
                        NavigationLink("Preview Profile") {
                            TeacherView(teacherId: teacherDetails.teacherID)
                        }
                        NavigationLink("Teaching Reviews") {
                            TeachersReviewsView(teacherId: teacherDetails.teacherID)
                        }
                    } header: {
                        Text("Teacher Details")
                    }
                }
                
            }
            .onChange(of: teacherDetailsUpdated, perform: { _ in
                vm.teacherDetails = global.teacherDetails
            })
            .onChange(of: vm.userDetailsStart, perform: { newUserDetails in
                global.userDetails = newUserDetails
            })
            .navigationTitle("Profile")
            .sheet(isPresented: $showImagePickerView) {
                ImagePicker(currentImageUrl: global.userDetails?.profileImageURL)
                    .presentationDetents([.medium])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    settingsLink
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    editableToggleButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    logoutButton
                }
            }
            .alert("Do you want to save changes?", isPresented: $showSaveChangesAlert) {
                Button("Save", action: {
                     Task {
                         await vm.updateUserDetails(token: global.token)
                     }
                 })
                 Button("Discard", role: .destructive, action: {
                     vm.userDetails = vm.userDetailsStart
                     vm.editable.toggle()
                 })
             }
        }
    }
    
    // MARK: VARIABLES
    private var settingsLink: some View {
        NavigationLink {
            SettingsView(teacherDetailsUpdated: $teacherDetailsUpdated)
        } label: {
            Image(systemName: "gear")
        }
    }
    
    private var editableToggleButton: some View {
        Button {
            if vm.userDetailsStart == vm.userDetails {
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
    
    private var userDetailsSection: some View {
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
                    .foregroundColor(vm.editable ? Color.theme.accent : Color.theme.primaryText)
                    .disabled(!vm.editable)
            }
            
            HStack {
                Text("Last Name")
                TextField("", text: $vm.userDetails.lastName)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(vm.editable ? Color.theme.accent : Color.theme.primaryText)
                    .disabled(!vm.editable)
            }
            
            HStack {
                Text("Email")
                TextField("", text: $vm.userDetails.email)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(vm.editable ? Color.theme.accent : Color.theme.primaryText)
                    .disabled(!vm.editable)
            }
            
            HStack {
                Text("Date of Birth")
                Spacer()
                DatePicker(selection: $vm.userDetails.formattedDob, in: ...Date.now, displayedComponents: .date) {}
                    .padding(.trailing, -10)
                    .labelsHidden()
                    .datePickerStyle(.automatic)
                    .colorInvert()
                    .colorMultiply(vm.editable ? Color.theme.accent : Color.theme.primaryText)
                    .disabled(!vm.editable)
            }
            
            HStack {
                Text("Password")
                Spacer()
                Button {
                    // TODO: Add update password flow
                } label: {
                    Text("Update")
                }
                .disabled(!vm.editable)
            }
            
            NavigationLink("My Reviews") {
                UsersReviewsView()
            }
            
            NavigationLink("My Favourites") {
                FavouriteTeachersView()
            }
            
        } header: {
            Text("User Details")
        }
    }
    
}

// MARK: PREVIEW
//struct ProfileView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        let userDetails = UserDetails(userID: 1, firstName: "Stephen", lastName: "Hanna", email: "shanna@gmail.com", dob: "1978-07-02T23:00:00.000Z", registeredTimestamp: "2022-10-03T16:52:49.000Z", profileImageURL: "https://musicapp-file-storage.s3.eu-west-1.amazonaws.com/DEC5451C.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAQZSA5A6ZTDLDHQIK%2F20230718%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20230718T100246Z&X-Amz-Expires=3600&X-Amz-Signature=2f48e91ec2eaaf0484c338958492d6b1a512037a7a121ba6dc8a4a5e79c1931e&X-Amz-SignedHeaders=host&x-id=GetObject")
//        ProfileView(userDetails: userDetails)
//            .environmentObject(dev.globalVM)
//    }
//}

