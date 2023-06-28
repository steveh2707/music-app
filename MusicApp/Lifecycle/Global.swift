//
//  Authentication.swift
//  MusicApp
//
//  Created by Steve on 15/06/2023.
//

import Foundation
import SwiftUI

class Global: ObservableObject {
    @Published var isValidated = false
    @Published var token: String = ""
    
    func logout() {
        self.isValidated = false
        self.token = ""
    }
    
    func login(token: String) {
        self.isValidated = true
        self.token = token
    }
    
    func test(token: String) -> Global {
        self.isValidated = true
        self.token = token
        return self
    }
    
}
