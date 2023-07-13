//
//  NewUserView.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import SwiftUI

struct SignupView: View {
    
    @EnvironmentObject var global: Global
    @StateObject var vm = SignUpVM()
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            Form {
                HeadingView()
                    .listRowBackground(Color.clear)

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
                
                submit
                    .listRowBackground(Color.clear)

                linksSection
                
            }
            .navigationTitle("Sign Up")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SignInView()
                    } label: {
                        Text("Sign In")
                    }
                }
            }
            .autocorrectionDisabled()
            .disabled(vm.submissionState == .submitting)
        }
        .onChange(of: vm.submissionState) { newState in
            if newState == .successful, let signInResponse = vm.signInResponse {
                global.login(signInResponse: signInResponse)
            }
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .overlay {
            if vm.submissionState == .submitting {
                ProgressView()
            }
        }
    }
    

    private var userDetailsSection: some View {
        Group {
            HStack {
                TextField("First Name", text: $vm.newUser.firstName)
                    .focused($focusedField, equals: .firstName)
                TextField("Last Name", text: $vm.newUser.lastName)
                    .focused($focusedField, equals: .lastName)
            }
            
            TextField("Email Address", text: $vm.newUser.email)
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .email)
            
            SecureField("Password", text: $vm.newUser.password)
                .focused($focusedField, equals: .password)
            
            DatePicker(selection: $vm.newUser.inputDob, in: ...Date.now, displayedComponents: .date) {
                Text("Date of Birth")
            }
            .datePickerStyle(.automatic)
            .focused($focusedField, equals: .dob)
            
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
    
    private var submit: some View {
        Button {
            focusedField = nil
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
    
    
    private var linksSection: some View {
        Section {
            NavigationLink {
                SignInView()
            } label: {
                Text("Already have an account?")
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
    }
    
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

extension SignupView {
    enum Field: Hashable {
        case firstName
        case lastName
        case email
        case password
        case dob
    }
}
