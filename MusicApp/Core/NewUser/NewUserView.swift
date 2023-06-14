//
//  NewUserView.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import SwiftUI

struct NewUserView: View {
    
    @StateObject var vm = NewUserVM()
    
    var body: some View {
        NavigationView {
                Form {

                    
                    Section {
                        firstName
                        lastName
                        email
                        password
                    } footer: {
                        
                        if case .validation(let err) = vm.error, let errorDesc = err.errorDescription {
                            Text(errorDesc)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    Section {
                        submit
                    }
                }

            
            .navigationTitle("New User")
            .onChange(of: vm.state) { formState in
                if formState == .successful {
//                    TO-DO do something if successful
                }
            }
            .alert(isPresented: $vm.hasError, error: vm.error) { }
            .overlay {
                if vm.state == .submitting {
                    ProgressView()
                }
            }
            
        }
        

    }
    
    var firstName: some View {
        TextField("First Name", text: $vm.newUser.firstName)
    }
    
    var lastName: some View {
        TextField("Last Name", text: $vm.newUser.lastName)
    }
    
    var email: some View {
        TextField("Email", text: $vm.newUser.email)
    }
    
    var password: some View {
        TextField("Password", text: $vm.newUser.password)
    }
    
    var submit: some View {
        Button("Submit") {
            Task {
                await vm.create()
            }

        }
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView()
    }
}
