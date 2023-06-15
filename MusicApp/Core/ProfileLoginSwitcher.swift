//
//  ProfileLoginSwitcher.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

struct ProfileLoginSwitcher: View {
//    @EnvironmentObject var musicAppVM: MusicAppVM
//    @StateObject var authentication = Authentication()
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        
        if !authentication.isValidated {
            SignupView()
                .environmentObject(authentication)
        } else {
            ProfileView()
                .environmentObject(authentication)
        }
        
//        VStack {
//            if (musicAppVM.isBusy) {
//                ProgressView()
//            } else if (!musicAppVM.isLoggedIn) {
//                NewUserView()
//                    .environmentObject(musicAppVM)
//            } else {
//                ProfileView()
//                    .environmentObject(musicAppVM)
//            }
//        }
    }
}

struct ProfileLoginSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        ProfileLoginSwitcher()
    }
}
