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
    
    @State private var showImagePickerView: Bool = false
    
    var body: some View {
        List {
            if let user = global.userDetails {
                
                HStack {
                    Text("Profile Image")
                    Spacer()
                    Button {
                        showImagePickerView.toggle()
                    } label: {
                        UserImageView(imageURL: user.profileImageURL)
                            .frame(width: 50, height: 50)
                    }
                    
                }
                

                
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
                    Text(user.lastName)
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text(user.email)
                }
                
                HStack {
                    Text("Date of Birth")
                    Spacer()
                    Text(user.formattedDob.asMediumDateString())
                }
                
                HStack {
                    Text("Password")
                    Spacer()
                    Text("Update Password")
                }
            }
            
            
        }
        .navigationTitle("Profile")
        .alert("Update "+updateFieldTitle, isPresented: $updateField) {
            
            TextField(updateFieldTitle, text: $newValue)
            Button("Save", action: {
                print("Updated")
            })
            Button("Cancel", role: .cancel, action: {})
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

