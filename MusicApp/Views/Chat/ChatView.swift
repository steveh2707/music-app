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
    
    var chatID: Int?
    var teacherID: Int?
    
    var userIsTeacher: Bool { vm.chat?.teacherID == global.teacherDetails?.teacherID }
    
    init(chatID: Int? = nil, teacherID: Int? = nil) {
        self.chatID = chatID
        self.teacherID = teacherID
    }
    

    var body: some View {
        VStack {
            
            if let chat = vm.chat {
                ScrollViewReader { value in
                    ScrollView {
                        
                        ForEach(chat.messages, id: \.self) { message in
                            HStack {
                                
                                var messageSent: Bool {
                                    message.senderID == global.userDetails?.userID
                                }

                                
                                if !messageSent {
                                    UserImageView(imageURL: userIsTeacher ? chat.student.profileImageURL : chat.teacher.profileImageURL)
                                        .frame(width: 30, height: 30)
                                } else {
                                    Spacer(minLength: 60)
                                }
                                
                                Text(message.message)
                                    .foregroundColor(messageSent ? Color.theme.primaryTextInverse : Color.theme.primaryText)
                                    .padding(10)
                                    .background(messageSent ? Color.theme.accent : Color.theme.backgroundSecondary)
                                    .cornerRadius(15)
                                if !messageSent {
                                    Spacer(minLength: 40)
                                }
                                
//                                if message.senderID == global.userDetails.userID {
//                                    UserImageView(imageURL: chat.profileImageURL)
//                                        .frame(width: 30, height: 30)
//                                } else {
//                                    Spacer(minLength: 60)
//                                }
//                                Text(message.message)
//                                    .foregroundColor(message.senderID == 1 ? Color.theme.primaryText : Color.theme.primaryTextInverse)
//                                    .padding(10)
//                                    .background(message.senderID == 1 ? Color.theme.backgroundSecondary : Color.theme.accent)
//                                    .cornerRadius(15)
//                                if message.senderID == 1 {
//                                    Spacer(minLength: 40)
//                                }
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
                    TextField("Type your message", text: $vm.newMessage.message, axis: .vertical)
                        .lineLimit(1...5)
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
                    
                    if !userIsTeacher {
                        NavigationLink {
                            TeacherView(teacherId: vm.chat?.teacherID ?? 0)
                            
                        } label: {
                            HStack {
                                UserImageView(imageURL: chat.teacher.profileImageURL)
                                    .frame(width: 30, height: 30)
                                Text(chat.teacher.fullName)
                                    .foregroundColor(Color.theme.primaryText)
                            }
                        }
                    } else {
                        HStack {
                            UserImageView(imageURL: chat.student.profileImageURL)
                                .frame(width: 30, height: 30)
                            Text(chat.student.fullName)
                                .foregroundColor(Color.theme.primaryText)
                        }
                    }
                    


                }
            }
        }
        .task {
            await vm.searchForChatUsingChatID(chatID: chatID, teacherID: teacherID, token: global.token)
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
        
        ChatView(chatID: 1)
            .environmentObject(dev.globalVM)
    }
}
