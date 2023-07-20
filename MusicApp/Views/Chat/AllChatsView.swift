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
    @State var searchText = ""
    
    var filteredChats: [ChatGeneral] {
        if searchText == "" {
            return vm.chats
        } else {
            return vm.chats.filter {
                $0.student.fullName.lowercased().contains(searchText.lowercased()) ||
                $0.teacher.fullName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredChats) { chat in
                    var userIsTeacher: Bool { chat.teacherID == global.teacherDetails?.teacherID }
                    
                    ZStack {
                        NavigationLink {
                            ChatView(chatID: chat.chatID)
                        } label: {
                            HStack(spacing: 20) {
                                UserImageView(imageURL: userIsTeacher ? chat.student.profileImageURL : chat.teacher.profileImageURL)
                                        .frame(width: 80, height: 80)
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack {
                                            if userIsTeacher {
                                                Image(systemName: "studentdesk")
                                            }
                                            Text(userIsTeacher ? chat.student.fullName : chat.teacher.fullName)
                                                .font(.title3)
                                        }
   
                                        if let message = chat.mostRecentMessage {
                                            Text(message)
                                                .font(.callout)
                                        }

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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    refresh
                }
            }
        }
        .searchable(text: $searchText)
        .task {
            await vm.getChats(token: global.token)
//            await global.fetchUnreadMessages()
        }
        .onChange(of: global.unreadMessages, perform: { newValue in
            Task {
                await vm.getChats(token: global.token)
            }
        })
        .overlay {
            if vm.viewState == .fetching{
                ProgressView()
            }
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }

    }
    
    
    var refresh: some View {
        Button {
            Task {
                await vm.getChats(token: global.token)
            }
        } label: {
            Image(systemName: "arrow.clockwise")
        }
        .disabled(vm.viewState == .fetching)
    }
}

struct AllChatsView_Previews: PreviewProvider {
    static var previews: some View {
        AllChatsView()
            .environmentObject(dev.globalVM)
    }
}
