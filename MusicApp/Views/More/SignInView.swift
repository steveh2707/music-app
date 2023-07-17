//
//  LoginView.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var global: Global
    @StateObject var vm = SignInVM()
    @FocusState private var focusedField: Field?
    @State private var navigationIsActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    HeadingView()
                        .listRowBackground(Color.clear)
                    
                    Section {
                        email
                        password
                    }
                    .disabled(vm.submissionState == .submitting)
                    
                    submit
                        .listRowBackground(Color.clear)
                    
                    Section {
                        NavigationLink {
                            SignupView()
                        } label: {
                            Text("New to Treble?")
                        }
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
                    
                    
#if DEBUG
                    Section {
                        if global.isValidated {
                            Button("Log out") {
                                global.logout()
                            }
                        } else {
                            Button("Use saved details") {
                                vm.credentials.email = "shanna@gmail.com"
                                vm.credentials.password = "password"
                                Task {
                                    await vm.login()
                                }
                            }
                        }
                    }
#endif
                    
                    
                }
                .textInputAutocapitalization(.never)
                
                
                if vm.submissionState == .submitting {
                    ProgressView()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SignupView()
                } label: {
                    Text("Sign Up")
                }
            }
        }
        .navigationTitle("Sign In")
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .onChange(of: vm.submissionState) { newState in
            if newState == .successful, let signInResponse = vm.signInResponse {
                global.login(signInResponse: signInResponse)
            }
        }
    }
    
    
    
    private var email: some View {
        TextField("Email", text: $vm.credentials.email)
            .focused($focusedField, equals: .email)
            .keyboardType(.emailAddress)
    }
    
    private var password: some View {
        SecureField("Password", text: $vm.credentials.password)
            .focused($focusedField, equals: .password)
    }
    
    private var submit: some View {
        Button {
            focusedField = nil
            Task {
                await vm.login()
            }
        } label: {
            HStack {
                Spacer()
                Text("Log In")
                Spacer()
            }
        }
        .padding()
        .background(Color.theme.accent)
        .opacity(vm.loginDisabled ? 0.6 : 1)
        .foregroundColor(Color.theme.primaryTextInverse)
        .clipShape(Capsule())
        .disabled(vm.loginDisabled)
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


extension SignInView {
    enum Field: Hashable {
        case email
        case password
    }
}
