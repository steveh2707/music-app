//
//  NewUser.swift
//  MusicApp
//
//  Created by Steve on 14/06/2023.
//

import Foundation

struct NewStudent: Encodable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var inputDob: Date = Date.now
    var tos: Bool = false
    
    var dob: String {
        inputDob.asSqlDateString()
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case inputDob = "input_dob"
        case tos
        case dob
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(dob, forKey: .dob)

    }
}
