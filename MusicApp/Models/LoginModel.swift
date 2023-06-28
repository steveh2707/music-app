//
//  LoginModel.swift
//  MusicApp
//
//  Created by Steve on 22/06/2023.
//

import Foundation


struct LoginResponse: Codable {
    let token: String

    enum CodingKeys: String, CodingKey {
        case token
    }
}
