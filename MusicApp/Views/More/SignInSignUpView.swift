//
//  SignInSignUpView.swift
//  MusicApp
//
//  Created by Steve on 14/07/2023.
//

import SwiftUI

/// View to allow new users to sign up to the app and let existing users sign in
struct SignInSignUpView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @StateObject var vm = SignInSignUpVM()
    @State var showSignIn = false
    
    // MARK: INITALIZATION
    var body: some View {
        NavigationStack {
            Form {
                signInSignUpPicker
                
                HeadingView()
                    .listRowBackground(Color.clear)
                
                if showSignIn {
                    signInView
                } else {
                    signUpView
                }
                
                Section {
                    NavigationLink {
                        MarkdownView(title: "Terms of Service", fileName: "TOS")
                    } label: {
                        Text("Terms of Service")
                    }
                    NavigationLink {
                        MarkdownView(title: "Privacy Policy", fileName: "PP")
                    } label: {
                        Text("Privacy Policy")
                    }
                }
            }
            .padding(.top, -10)
            .navigationBarTitleDisplayMode(.inline)
#if DEBUG
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("Student") {
                            vm.credentials.email = "shanna@gmail.com"
                            vm.credentials.password = "password"
                            Task {
                                await vm.login()
                            }
                        }
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
                    vm.error = nil
                    vm.newUser = NewStudent()
                    global.login(signInResponse: signInResponse)
                }
            }
        }
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    // picker to allow switching between sign in and sign up screens
    private var signInSignUpPicker: some View {
        Picker("Sign In / Sign Up", selection: $showSignIn) {
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
    }

    
    // sign up screen
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
    
    // section for users to fill in their details for sign up
    private var userDetailsSection: some View {
        Group {
            HStack {
                TextField("First Name", text: $vm.newUser.firstName)
                    .disableAutocorrection(true)
                TextField("Last Name", text: $vm.newUser.lastName)
                    .disableAutocorrection(true)
            }
            
            TextField("Email Address", text: $vm.newUser.email)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            SecureField("Password", text: $vm.newUser.password)
            
            DatePicker(selection: $vm.newUser.inputDob, in: ...Date.now, displayedComponents: .date) {
                Text("Date of Birth")
            }
            .datePickerStyle(.automatic)
            
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
    
    // button to allow users to post details to API to create account
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
    
    
    // sign in screen where user can enter email and password
    private var signInView: some View {
        Group {
            Section {
                TextField("Email", text: $vm.credentials.email)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $vm.credentials.password)
                
            }
            .disabled(vm.submissionState == .submitting)
            
            signInButton
                .listRowBackground(Color.clear)
        }
    }
    
    
    // button to send username and password to API to validate
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

// MARK: PREVIEW

struct SignInSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInSignUpView()
            .environmentObject(dev.globalStudentVM)
    }
}
