//
//  SignInSignUpView.swift
//  MusicApp
//
//  Created by Steve on 14/07/2023.
//

import SwiftUI

struct SignInSignUpView: View {
    
    @EnvironmentObject var global: Global
    @StateObject var vm = SignInSignUpVM()
    @State var showSignIn = false
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                Picker("Teat", selection: $showSignIn) {
                    Text("Sign Up")
                        .tag(false)
                    Text("Sign In")
                        .tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.top,-10)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding(.bottom)
                
                HeadingView()
                    .listRowBackground(Color.clear)
                
                if !showSignIn {
                    signUpView
                } else {
                    signInView
                }
                Section {
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("Terms of Service")
                    }
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("Privacy Policy")
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
#if DEBUG
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if global.isValidated {
                        Button("Log out") {
                            global.logout()
                        }
                    } else {
                        Button("Student") {
                            vm.credentials.email = "shanna@gmail.com"
                            vm.credentials.password = "password"
                            Task {
                                await vm.login()
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !global.isValidated {
                        Button("Teacher") {
                            vm.credentials.email = "johnsmith@hotmail.co.uk"
                            vm.credentials.password = "password"
                            Task {
                                await vm.login()
                            }
                        }
                    }
                }
            }
#endif
            .alert(isPresented: $vm.hasError, error: vm.error) { }
            .onChange(of: vm.submissionState) { newState in
                if newState == .successful, let signInResponse = vm.signInResponse {
                    global.login(signInResponse: signInResponse)
                }
            }
        }
    }

    
    private var signUpView: some View {
        Group {
            Section {
                userDetailsSection
                
            } footer: {
                if case .validation(let err) = vm.error, let errorDesc = err.errorDescription {
                    HStack {
                        Spacer()
                        Text(errorDesc)
                            .foregroundStyle(.red)
                        Spacer()
                    }
                }
            }
            
            signUpButton
                .listRowBackground(Color.clear)
        }
    }
    
    
    private var userDetailsSection: some View {
        Group {
            HStack {
                TextField("First Name", text: $vm.newUser.firstName)
                //                    .focused($focusedField, equals: .firstName)
                TextField("Last Name", text: $vm.newUser.lastName)
                //                    .focused($focusedField, equals: .lastName)
            }
            
            TextField("Email Address", text: $vm.newUser.email)
                .keyboardType(.emailAddress)
            //                .focused($focusedField, equals: .email)
            
            SecureField("Password", text: $vm.newUser.password)
            //                .focused($focusedField, equals: .password)
            
            DatePicker(selection: $vm.newUser.inputDob, in: ...Date.now, displayedComponents: .date) {
                Text("Date of Birth")
            }
            .datePickerStyle(.automatic)
            //            .focused($focusedField, equals: .dob)
            
            Button {
                vm.newUser.tos.toggle()
            } label: {
                HStack{
                    Image(systemName: vm.newUser.tos ? "checkmark.square": "square")
                        .font(.title3)
                        .padding(.trailing, 5)
                    
                    Text("I agree to the Terms of Servce and acknowledge the Privacy Statement")
                }
                .padding(.vertical, 2.0)
                .foregroundColor(.primary)
                .font(.footnote)
            }
        }
        
    }
    
    
    private var signUpButton: some View {
        Button {
            Task {
                await vm.signUp()
            }
        } label: {
            HStack {
                Spacer()
                Text("Sign Up")
                Spacer()
            }
        }
        .padding()
        .background(Color.theme.accent)
        .foregroundColor(Color.theme.primaryTextInverse)
        .clipShape(Capsule())
    }
    
    
    private var signInView: some View {
        Group {
            Section {
                TextField("Email", text: $vm.credentials.email)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $vm.credentials.password)
            }
            .disabled(vm.submissionState == .submitting)
            
            signInButton
                .listRowBackground(Color.clear)
        }
    }
    
    
    private var signInButton: some View {
        Button {
            Task {
                await vm.login()
            }
        } label: {
            HStack {
                Spacer()
                Text("Sign In")
                Spacer()
            }
        }
        .padding()
        .background(Color.theme.accent)
        .foregroundColor(Color.theme.primaryTextInverse)
        .clipShape(Capsule())
        .opacity(vm.loginDisabled ? 0.6 : 1)
        .disabled(vm.loginDisabled)
    }
    

    
}

struct SignInSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInSignUpView()
    }
}
