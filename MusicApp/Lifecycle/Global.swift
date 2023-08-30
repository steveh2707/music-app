//
//  Authentication.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import Foundation

class Global: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var selectedTab = 1
    
    @Published var isValidated = false
    @Published var token: String = ""
    @Published var userDetails: UserDetails? = nil
    @Published var teacherDetails: TeacherDetails? = nil
    @Published var unreadMessages: Int = 0
    
    @Published var selectedInstrument: Instrument? = nil
    @Published var selectedGrade: Grade? = nil
    @Published var lessonCost: Int? = nil
    
    @Published var instruments: [Instrument] = []
    @Published var grades: [Grade] = []
    
    @Published var viewState: ViewState?
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: NetworkingManager.NetworkingError?
    
    var bookingCancellationMinDays = 2
    
    
    // MARK: FUNCTIONS
    
    /// Logs in user from API response.
    ///
    /// Takes variables from API response and assigns them to local variables.
    /// - Parameter signInResponse: Response provided by API with authentication details.
    func login(signInResponse: SignInResponse) {
        self.isValidated = true
        self.token = signInResponse.token
        self.userDetails = signInResponse.userDetails
        if let teacherDetails = signInResponse.teacherDetails {
            self.teacherDetails = teacherDetails
        }
    }
    
    /// Logs out user.
    ///
    /// Removes user's details from all local variables.
    func logout() {
        self.isValidated = false
        self.token = ""
        self.userDetails = nil
        self.teacherDetails = nil
    }
    
    /// Update user's image to the URL provided.
    /// - Parameter url: New Image URL to be assigned to user's details
    func updateImageUrl(url: String?) {
        if let url {
            self.userDetails?.profileImageURL = url
        }
    }

    @MainActor
    /// Makes an API call to get number of unread chat messages for the user and assigns to local variable.
    func fetchUnreadMessages() async {
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            let decodedResponse = try await NetworkingManager.shared.request(.allUnreadChats(token: token), type: UnreadResponse.self)
            self.unreadMessages = decodedResponse.unreadMessages
        } catch {
            print(error)
        }
    }
    
    @MainActor
    /// Makes an API call to get instrument and grades available and assigns them to local variables.
    func getConfiguration() async {
        if self.viewState == .fetching { return }
        
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
    
    
#if DEBUG
    /// Returns an instance of the Global class authentication provided.
    ///
    /// Funtion returns instance of Global class, setting token to value provided and setting isValidated to true. Function used to get authenticated instances of Global class to be used for PreviewProvider. Should only ever run in DEBUG mode.
    /// - Parameter token: JWT to be assigned to class.
    /// - Returns: Authenticated instance of Global class
    func test(token: String) -> Global {
        self.isValidated = true
        self.token = token
        return self
    }
#endif

  
}
