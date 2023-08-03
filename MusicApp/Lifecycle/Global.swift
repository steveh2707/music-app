//
//  Authentication.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import Foundation

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
    @Published var userDetails: UserDetails? = nil
    @Published var teacherDetails: TeacherDetails? = nil
    @Published var unreadMessages: Int = 0
    
    @Published var selectedInstrument: Instrument? = nil
    @Published var selectedGrade: Grade? = nil
    @Published var lessonCost: Double? = nil
    
    
    func login(signInResponse: SignInResponse) {
        self.isValidated = true
        self.token = signInResponse.token
        self.userDetails = signInResponse.userDetails
        if let teacherDetails = signInResponse.teacherDetails {
            self.teacherDetails = teacherDetails
        }
        Task {
            await fetchUnreadMessages()
        }
    }
    
    func logout() {
        self.isValidated = false
        self.token = ""
        self.userDetails = nil
        self.teacherDetails = nil
    }
    
    func updateImageUrl(url: String?) {
        if let url {
            self.userDetails?.profileImageURL = url
        }
    }

    @MainActor
    func fetchUnreadMessages() async {
        do {
            let decodedResponse = try await NetworkingManager.shared.request(.allUnreadChats(token: token), type: UnreadResponse.self)
            self.unreadMessages = decodedResponse.unreadMessages
        } catch {
            print(error)
        }
        
//        do {
//            // Schedule the next execution of the function after 30 seconds
//            try await Task.sleep(nanoseconds: 60 * 1_000_000_000)
//        } catch {
//            print(error)
//        }

//        if isValidated {
//            await fetchUnreadMessages()
//        }

    }
    
    @Published var instruments: [Instrument] = []
    @Published var grades: [Grade] = []
    
    @Published var viewState: ViewState?
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    
    @MainActor
    /// Makes an API call to get instrument and grades available and assigns them to local variables
    func getConfiguration() async {
        if self.viewState == .fetching { return }
        
        print("Getting config")
        
        viewState = .fetching
        defer { viewState = .finished }
       
        do {
            let decodedResponse = try await NetworkingManager.shared.request(.configuration, type: Configuration.self)
            self.instruments = decodedResponse.instruments
            self.grades = decodedResponse.grades

        } catch {
            if let errorCode = (error as NSError?)?.code, errorCode == NSURLErrorCancelled {
                return
            }
            
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    
    
    func test(token: String) -> Global {
        self.isValidated = true
        self.token = token
        return self
    }
  
}
