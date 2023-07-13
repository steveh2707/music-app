//
//  ChatView.swift
//  MusicApp
//
//  Created by Steve on 21/06/2023.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var global: Global
    @StateObject var vm = ChatVM()
    
    @Namespace var bottomID
    
    let teacherId: Int
    
    var body: some View {
        VStack {
            
            if let chat = vm.chat {
                ScrollViewReader { value in
                    
                    ScrollView {
                        
                        
                        ForEach(chat.messages, id: \.self) { message in
                            HStack {
                                
                                if message.senderID == 1 {
                                    UserImageView(imageURL: chat.profileImageURL)
                                        .frame(width: 30, height: 30)
                                } else {
                                    Spacer(minLength: 60)
                                }
                                Text(message.message)
                                    .foregroundColor(message.senderID == 1 ? Color.theme.primaryText : Color.theme.primaryTextInverse)
                                    .padding(10)
                                    .background(message.senderID == 1 ? Color.theme.backgroundSecondary : Color.theme.accent)
                                    .cornerRadius(15)
                                if message.senderID == 1 {
                                    Spacer(minLength: 40)
                                }
                            }
                            
                        }
                        .padding(.horizontal)
                        .onAppear {
                            value.scrollTo(bottomID)
                        }
                        .onChange(of: chat.messages) { _ in
                            value.scrollTo(bottomID)
                        }
                        Spacer()
                            .id(bottomID)
                    }
                }
                
                HStack {
                    TextField("Type your message", text: $vm.newMessage.message)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        Task {
                            await vm.sendChatMessage(teacherId: chat.teacherID, token: global.token)
                            vm.newMessage.message = ""
                        }
                        
                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .rotationEffect(.degrees(45))
                            .font(.title)
                    }
                    .disabled(vm.newMessage.message.isEmpty)
                    
                }
                .padding()
            }
            
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let chat = vm.chat {
                    NavigationLink {
                        TeacherView(teacherId: teacherId)
                    } label: {
                        HStack {
                            Spacer()
                            UserImageView(imageURL: chat.profileImageURL)
                                .frame(width: 30, height: 30)
                            Text("\(chat.teacherFirstName) \(chat.teacherLastName)")
                                .foregroundColor(Color.theme.primaryText)
                            Spacer()
                        }
                    }
                }
            }
        }
        //        }
        .task {
            await vm.searchForChat(teacherId: teacherId, token: global.token)
//            await global.fetchUnreadMessages()
        }
        .overlay {
            if vm.viewState == .fetching {
                ProgressView()
            }
        }
        
        
    }
}

struct ChatView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ChatView(teacherId: 1)
            .environmentObject(dev.globalVM)
    }
}
