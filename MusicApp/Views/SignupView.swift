//
//  NewUserView.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import SwiftUI

struct SignupView: View {
    
    @EnvironmentObject var global: Global
    @StateObject var vm = SignupVM()
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            Form {
                HeadingView()
                    .listRowBackground(Color.clear)

                Section {
                    HStack {
                        firstName
                        lastName
                    }
                    email
                    password
                    dob
                    tos
                    
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

                Section {
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Already have an account?")
                    }
//                    NavigationLink {
//                        EmptyView()
//                    } label: {
//                        Text("Sign up as Teacher?")
//                    }
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
            .navigationTitle("Sign Up")
//            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Login")
                    }
                }
            }
            .autocorrectionDisabled()
            .disabled(vm.state == .submitting)
            .onChange(of: vm.state) { newState in
                if newState == .successful {
                    global.isValidated = true
                }
            }
            .alert(isPresented: $vm.hasError, error: vm.error) { }
            .onChange(of: vm.state) { newState in
                if newState == .successful {
                    global.login(token: vm.loginResponse?.token ?? "")
                }
            }
            .overlay {
                if vm.state == .submitting {
                    ProgressView()
                }
            }
        }
    }
    
    private var firstName: some View {
        TextField("First Name", text: $vm.newUser.firstName)
            .focused($focusedField, equals: .firstName)
    }
    
    private var lastName: some View {
        TextField("Last Name", text: $vm.newUser.lastName)
            .focused($focusedField, equals: .lastName)
    }
    
    private var email: some View {
        TextField("Email Address", text: $vm.newUser.email)
            .keyboardType(.emailAddress)
            .focused($focusedField, equals: .email)
    }
    
    private var password: some View {
        SecureField("Password", text: $vm.newUser.password)
            .focused($focusedField, equals: .password)
    }
    
    private var dob: some View {
        DatePicker(selection: $vm.newUser.inputDob, in: ...Date.now, displayedComponents: .date) {
            Text("Date of Birth")
        }
        .datePickerStyle(.automatic)
        .focused($focusedField, equals: .dob)
    }
    
    private var tos: some View {
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
