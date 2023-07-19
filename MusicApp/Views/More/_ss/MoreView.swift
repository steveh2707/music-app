//
//  Profile.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import SwiftUI

struct MoreView: View {
    //    @EnvironmentObject var musicAppVM: MusicAppVM
    @EnvironmentObject var global: Global
    
    var body: some View {
        NavigationStack {
            
            List {
                
                Section {
                    if global.isValidated {
                        
                        NavigationLink {
//                            ProfileView()
                        } label: {
                            HStack {
                                Image(systemName: "person")
                                Text("Profile")
                            }
                        }
                        
                        NavigationLink {
                            EmptyView()
                        } label: {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Bookings")
                            }
                        }
                        
                        NavigationLink {
                            EmptyView()
                        } label: {
                            HStack {
                                Image(systemName: "music.note")
                                Text("Become a Teacher")
                            }
                        }
                    } else {
                        
                        NavigationLink {
                            SignInView()
                        } label: {
                            HStack {
                                Image(systemName: "person")
                                Text("Sign In")
                            }
                        }
                        
                        NavigationLink {
                            SignupView()
                        } label: {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Text("Sign Up")
                            }
                        }
                    }
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                    }

                } header: {
                    Text("Account")
                }
                
                Section {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Terms of Service")
                        }
                    }
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: "doc.plaintext")
                            Text("Privacy Policy")
                        }
                    }
                } header: {
                    Text("Support")
                }
                
//#if DEBUG
//
//                Section {
//                    if global.isValidated {
//                        Button("Log out") {
//                            global.logout()
//                        }
//                    } else {
//                        Button("Use saved details") {
//                            global.login(token: "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNiwiZmlyc3RfbmFtZSI6IlN0ZXBoZW4iLCJsYXN0X25hbWUiOiJIYW5uYSIsImVtYWlsIjoic2hhbm5hQGdtYWlsLmNvbSIsInBhc3N3b3JkX2hhc2giOiIkMmIkMTAkLklNRUVLRGguY0pLSm5Cd2dUS211dUZyL3JYR1dVVjYzVjUyRFpJYzdqRWYwT29vSmJLRVMiLCJkb2IiOiIxOTc4LTA3LTAyVDIzOjAwOjAwLjAwMFoiLCJyZWdpc3RlcmVkX3RpbWVzdGFtcCI6IjIwMjItMTAtMDNUMTY6NTI6NDkuMDAwWiIsInByb2ZpbGVfaW1hZ2VfdXJsIjpudWxsfQ.4LvGCYlmX5rBZ4ZrS6BReSe9nTeNDBtfa59sk2UQEzk")
//                        }
//                    }
//                }
//#endif
                
            }
            .navigationTitle("More")
            
        
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if global.isValidated {
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
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
            .environmentObject(dev.globalVM)
        MoreView()
            .environmentObject(dev.globalVMNotAuthenticated)
    }
}
