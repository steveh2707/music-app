//
//  Authentication.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import Foundation
import SwiftUI

struct UnreadResponse: Codable {
    let unreadMessages: Int

    enum CodingKeys: String, CodingKey {
        case unreadMessages = "unread_messages"
    }
}


class Global: ObservableObject {
    
    @Published var selectedTab = 1
    
    @Published var isValidated = false
    @Published var token: String = ""
    @Published var unreadMessages: Int = 0
    
    @Published var selectedInstrument: Instrument? = nil
    @Published var selectedGrade: Grade? = nil
    
    
    
    func logout() {
        self.isValidated = false
        self.token = ""
    }
    
    func login(token: String) {
        self.isValidated = true
        self.token = token
        Task {
            await fetchUnreadMessages(token: token)
        }
    }
    
    func test(token: String) -> Global {
        self.isValidated = true
        self.token = token
        return self
    }

    
    @MainActor
    func fetchUnreadMessages(token: String) async {
        do {
            let decodedResponse = try await NetworkingManager.shared.request(.allUnreadChats(token: token), type: UnreadResponse.self)
            self.unreadMessages = decodedResponse.unreadMessages
        } catch {

        }
    }
    
}
