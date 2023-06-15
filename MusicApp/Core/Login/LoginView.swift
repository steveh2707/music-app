//
//  LoginView.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authentication: Authentication
    @StateObject var vm = LoginVM()
    @FocusState private var focusedField: Field?
    @State private var navigationIsActive = false
    
    var body: some View {
        NavigationStack {
            Form {
                heading
                    .listRowBackground(Color.clear)
                
                Section {
                    email
                    password
                }
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
            .disabled(vm.state == .submitting)
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .onChange(of: vm.state) { newState in
            if newState == .successful {
                authentication.isValidated = true
            }
        }
    }
    
    private var heading: some View {
        HStack {
            Spacer()
            Image(systemName: "music.note.list")
                .font(.largeTitle)
            Text("Treble")
                .font(.largeTitle)
                .monospaced()
                .kerning(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/)
            Spacer()
        }
        .padding(.top)
    }
    
    
    private var email: some View {
        TextField("Email", text: $vm.credentials.email)
//            .keyboardType(.emailAddress)
            .focused($focusedField, equals: .email)
    }
    
    private var password: some View {
        TextField("Password", text: $vm.credentials.password)
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
        .background(Color(red: 0, green: 0, blue: 0.5))
        .foregroundColor(.white)
        .clipShape(Capsule())
        
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
