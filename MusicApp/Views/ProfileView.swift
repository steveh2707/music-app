//
//  Profile.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

struct ProfileView: View {
    //    @EnvironmentObject var musicAppVM: MusicAppVM
    @EnvironmentObject var global: Global
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                Text("You're logged in, woooooo!")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        global.logout()
                    } label: {
                        Text("Log Out")
                    }
                }
            }
            
        }
        
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
