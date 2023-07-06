//
//  AllChatsView.swift
//  MusicApp
//
//  Created by Steve on 23/06/2023.
//

import SwiftUI

struct AllChatsView: View {
    
    @EnvironmentObject var global: Global
    @StateObject var vm = AllChatsVM()
    @State var hasAppeared = false
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.chats) { chat in
                    
                    ZStack {
                        
                        NavigationLink {
                            ChatView(teacherId: chat.teacherID)
                        } label: {
                            HStack(spacing: 20) {
                                UserImageView(imageURL: chat.profileImageURL ?? "")
                                    .frame(width: 80, height: 80)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(chat.firstName) \(chat.lastName)")
                                        .font(.title3)
                                    Text(chat.mostRecentMessage ?? "")
                                        .font(.callout)
                                }
                                Spacer()
                            }
                        }
                        if chat.unreadMessages > 0 {
                            HStack {
                                Spacer()
                                NotificationCountView(value: chat.unreadMessages)
                            }
                        }
 
                        
                    }

                }
            }
            .navigationTitle("Chats")
        }
        .searchable(text: $searchText)
        .task {
            await vm.getChats(token: global.token)
        }
        .overlay {
            if vm.state == .submitting {
                ProgressView()
            }
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
//        .sheet(isPresented: $showIndividualChat) {
//            ChatView(teacherId: 1)
//        }
    }
}

struct AllChatsView_Previews: PreviewProvider {
    static var previews: some View {
        AllChatsView()
            .environmentObject(dev.globalVM)
    }
}
