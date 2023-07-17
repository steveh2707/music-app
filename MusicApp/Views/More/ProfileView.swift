//
//  ProfileView.swift
//  MusicApp
//
//  Created by Steve on 11/07/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var global: Global
    
    @State var updateField = false
    @State var updateFieldTitle = ""
    @State var newValue = ""
    @State var updatedView = 0
    
    @State private var showImagePickerView: Bool = false
    
    var body: some View {
        List {
            
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
            if let user = global.userDetails {
                
                HStack {
                    Text("First Name")
                    Spacer()
                    Button {
                        updateField = true
                        updateFieldTitle = "First Name"
                    } label: {
                        Text(user.firstName)
                    }
                    
                }
            
                HStack {
                    Text("Last Name")
                    Spacer()
                    Button {
                        updateField = true
                        updateFieldTitle = "Last Name"
                    } label: {
                        Text(user.lastName)
                    }
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Button {
                        updateField = true
                        updateFieldTitle = "Email"
                    } label: {
                        Text(user.email)
                    }
                }
                
                HStack {
                    Text("Date of Birth")
                    Spacer()
                    Button {
                        updateField = true
                        updateFieldTitle = "Dob"
                    } label: {
                        Text(user.formattedDob.asMediumDateString())
                    }
                }
                
                HStack {
                    Text("Password")
                    Spacer()
                    Button {
                        updateField = true
                        updateFieldTitle = "Password"
                    } label: {
                        Text("Update")
                    }
                }
            }
            
            
        }
        .navigationTitle("Profile")
        .alert("Update "+updateFieldTitle, isPresented: $updateField) {
            
            TextField(updateFieldTitle, text: $newValue)
            Button("Save", action: {
                newValue = ""
                print("Updated")
            })
            Button("Cancel", role: .cancel, action: {
                newValue = ""
            })
        }
        .sheet(isPresented: $showImagePickerView) {
            ImagePicker(currentImageUrl: global.userDetails?.profileImageURL)
                .presentationDetents([.medium])
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(dev.globalVM)
    }
}

