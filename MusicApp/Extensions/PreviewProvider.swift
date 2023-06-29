//
//  PreviewProvider.swift
//  MusicApp
//
//  Created by Steve on 23/06/2023.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {}
    
    let globalVM = Global().test(token: "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNiwiZmlyc3RfbmFtZSI6IlN0ZXBoZW4iLCJsYXN0X25hbWUiOiJIYW5uYSIsImVtYWlsIjoic2hhbm5hQGdtYWlsLmNvbSIsInBhc3N3b3JkX2hhc2giOiIkMmIkMTAkLklNRUVLRGguY0pLSm5Cd2dUS211dUZyL3JYR1dVVjYzVjUyRFpJYzdqRWYwT29vSmJLRVMiLCJkb2IiOiIxOTc4LTA3LTAyVDIzOjAwOjAwLjAwMFoiLCJyZWdpc3RlcmVkX3RpbWVzdGFtcCI6IjIwMjItMTAtMDNUMTY6NTI6NDkuMDAwWiIsInByb2ZpbGVfaW1hZ2VfdXJsIjpudWxsfQ.4LvGCYlmX5rBZ4ZrS6BReSe9nTeNDBtfa59sk2UQEzk")
    
    let globalVMNotAuthenticated = Global()
}

