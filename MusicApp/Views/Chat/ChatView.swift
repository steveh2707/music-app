//
//  ChatView.swift
//  MusicApp
//
//  Created by Steve on 21/06/2023.
//

import SwiftUI

struct ChatView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @StateObject var vm = ChatVM()
    @Namespace var bottomID
    
    var chatID: Int?
    var teacherID: Int?
    
    var userIsTeacher: Bool { vm.chat?.teacherID == global.teacherDetails?.teacherID }
    
    
    // MARK: INITALIZATION
    init(chatID: Int? = nil, teacherID: Int? = nil) {
        self.chatID = chatID
        self.teacherID = teacherID
    }
    
    
    // MARK: BODY
    var body: some View {
        VStack {
            if let chat = vm.chat {
                ScrollViewReader { value in
                    ScrollView {
                        ForEach(chat.messages, id: \.self) { message in
                            displayMessage(message: message)
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
                messageInput
            }
            
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if userIsTeacher {
                    studentNameAndImage
                } else {
                    teacherLink
                }
            }
        }
        .task {
            await vm.searchForChatUsingChatIdOrTeacherId(chatID: chatID, teacherID: teacherID, token: global.token)
        }
        .overlay {
            if vm.viewState == .fetching {
                ProgressView()
            }
        }
        
        
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    /// Display a message on screen.
    ///
    /// Layout and colour of message changed depending on whether it was a sent or received message.
    /// - Parameter message: the message to be displayed
    /// - Returns: view with the message displayed.
    private func displayMessage(message: Message) -> some View {
        HStack {
            if let chat = vm.chat {
                
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
            }
        }
    }
    
    // textfield input for user to enter message and send button to send message to API
    private var messageInput: some View {
        HStack {
            TextField("Type your message", text: $vm.newMessage.message, axis: .vertical)
                .lineLimit(1...5)
                .textFieldStyle(.roundedBorder)
            Button {
                Task {
                    await vm.sendChatMessage(token: global.token)
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
    
    // Image and name of teacher with link to their profile
    private var teacherLink: some View {
        NavigationLink {
            TeacherView(teacherId: vm.chat?.teacherID ?? 0)
        } label: {
            if let chat = vm.chat {
                HStack {
                    UserImageView(imageURL: chat.teacher.profileImageURL)
                        .frame(width: 30, height: 30)
                    Text(chat.teacher.fullName)
                        .foregroundColor(Color.theme.primaryText)
                }
            }
        }
    }
    
    // Image and name of student
    private var studentNameAndImage: some View {
        HStack {
            if let chat = vm.chat {
                UserImageView(imageURL: chat.student.profileImageURL)
                    .frame(width: 30, height: 30)
                Text(chat.student.fullName)
                    .foregroundColor(Color.theme.primaryText)
            }
        }
    }
}

// MARK: PREVIEW

struct ChatView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatView(chatID: 1)
            .environmentObject(dev.globalStudentVM)
    }
}
