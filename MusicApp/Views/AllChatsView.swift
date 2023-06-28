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
        NavigationView {
            List {
                ForEach(vm.chats) { chat in
                    
                    NavigationLink {
                        ChatView(teacherId: chat.teacherID)
                    } label: {
                        HStack(spacing: 20) {
                            UserImageView(imageURL: chat.profileImageURL ?? "")
                                .frame(width: 80, height: 80)
                            Text("\(chat.firstName) \(chat.lastName)")
                                .font(.title3)
                            Spacer()
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
    }
}

struct AllChatsView_Previews: PreviewProvider {
    static var previews: some View {
        AllChatsView()
            .environmentObject(dev.globalVM)
    }
}
