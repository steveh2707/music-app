//
//  ProfileLoginSwitcher.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

struct ProfileLoginSwitcher: View {

    @EnvironmentObject var global: Global
    
    var body: some View {
        
        if !global.isValidated {
            SignupView()
                .environmentObject(global)
        } else {
            ProfileView()
                .environmentObject(global)
        }
        
    }
}

struct ProfileLoginSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        ProfileLoginSwitcher()
            .environmentObject(dev.globalVM)
    }
}
