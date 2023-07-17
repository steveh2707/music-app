//
//  SignInSignUpView.swift
//  MusicApp
//
//  Created by Steve on 14/07/2023.
//

import SwiftUI

struct SignInSignUpView: View {
    @State var showSignIn = true
    
    var body: some View {
        NavigationStack {
            Button("Switch") {
                showSignIn.toggle()
            }
            if showSignIn {
                SignInView()
            } else {
                SignupView()
            }
        }
    }
}

struct SignInSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInSignUpView()
    }
}
