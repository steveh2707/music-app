//
//  SignInSignUpVM.swift
//  MusicApp
//
//  Created by Steve on 17/07/2023.
//

import Foundation

/// View model for handling all business logic of Sign In Sign Up View
class SignInSignUpVM: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var credentials = Credentials()
    @Published var newUser = NewStudent()
    
    @Published var submissionState: SubmissionState?
    @Published var hasError = false
    @Published var error: FormError?
    @Published var signInResponse: SignInResponse? = nil
    
    private let networkingManager: NetworkingManagerImpl!
    private let validator: SignupValidatorImp!
    
    // MARK: INITALIZATION
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared,
         validator: SignupValidatorImp = SignupValidator()) {
        self.networkingManager = networkingManager
        self.validator = validator
    }
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    
    @MainActor
    /// Function to interface with API to allow a user to sign in with existing details
    func login() async {
        
        do {
            submissionState = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(credentials)
            
            self.signInResponse = try await networkingManager.request(session: .shared, .login(submissionData: data), type: SignInResponse.self)
            
            credentials = Credentials()
            submissionState = .successful
            
        } catch {
            self.hasError = true
            self.submissionState = .unsuccessful
            
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
            default:
                self.error = .system(error: error)
            }
        }
    }
    
    
    @MainActor
    /// Function to interface with API  to sign up with valid details
    func signUp() async {
    
        do {
            try validator.validate(newUser)
            
            submissionState = .submitting
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(newUser)
            
            self.signInResponse = try await networkingManager.request(session: .shared, .newUser(submissionData: data), type: SignInResponse.self)
            
            newUser = NewStudent()
            submissionState = .successful
            
        } catch {
            
            self.hasError = true
            self.submissionState = .unsuccessful
            
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
            case is SignupValidator.NewUserValidatorError:
                self.error = .validation(error: error as! SignupValidator.NewUserValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
        
    }
}
