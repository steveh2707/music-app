//
//  NewUser.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import Foundation

struct NewUser: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
}
