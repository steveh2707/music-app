//
//  Profile.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

struct ProfileView: View {
//    @EnvironmentObject var musicAppVM: MusicAppVM
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                Text("You're logged in, woooooo!")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        authentication.isValidated = false
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out")
                            Spacer()
                        }
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
