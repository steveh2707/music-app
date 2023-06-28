//
//  LoginView.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var global: Global
    @StateObject var vm = LoginVM()
    @FocusState private var focusedField: Field?
    @State private var navigationIsActive = false
    
    var body: some View {
        NavigationStack {
            Form {
                HeadingView()
                    .listRowBackground(Color.clear)
                
                Section {
                    email
                    password
                }
                .disabled(vm.state == .submitting)
                
                submit
                    .listRowBackground(Color.clear)
                
                if vm.state == .submitting {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .textInputAutocapitalization(.never)
            
        }
        .navigationTitle("Log In")
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .onChange(of: vm.state) { newState in
            if newState == .successful {
                global.login(token: vm.loginResponse?.token ?? "")
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
        LoginView()
    }
}


extension LoginView {
    enum Field: Hashable {
        case email
        case password
    }
}
