//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import SwiftUI

@main
struct MusicApp: App {
    
    @StateObject var global = Global()

    
    var body: some Scene {
        WindowGroup {
            
            TabView(selection: $global.selectedTab) {
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                    .task {
                        if global.isValidated {
                            await global.fetchUnreadMessages()
                        }
                    }
                
                if global.isValidated {
                    AllChatsView()
                        .tabItem {
                            Image(systemName: "bubble.left.and.bubble.right")
                            Text("Chats")
                        }
                        .badge(global.unreadMessages)
                        .tag(2)
                        .task {
                            if global.isValidated {
                                await global.fetchUnreadMessages()
                            }
                        }
                }
                
                if global.isValidated {
                    UserBookingsView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Bookings")
                        }
                        .tag(4)
                        .task {
                            if global.isValidated {
                                await global.fetchUnreadMessages()
                            }
                        }
                }
                
                if global.isValidated, global.userDetails != nil {
                    ProfileView(userDetails: global.userDetails!, teacherDetails: global.teacherDetails)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")

                        }
                        .tag(3)
                        .task {
                            if global.isValidated {
                                await global.fetchUnreadMessages()
                            }
                        }
                        
                } else {
                    SignInSignUpView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                            
                        }
                        .tag(3)
                }

            
//                SignInSignUpView()
//                    .tabItem {
//                        Image(systemName: "ellipsis")
//                        Text("Sign In")
//
//                    }
//                    .tag(5)

            }
            .environmentObject(global)
//            .task {
//                if global.isValidated {
//                    await global.fetchUnreadMessages()
//                }
//            }
            .onAppear {
#if DEBUG
                UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
#endif
            }
            .task {
                if global.viewState != .fetching && global.instruments.isEmpty {
                    await global.getConfiguration()
                }
            }
            
        }
        
        
        
    }
}
